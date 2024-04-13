locals {
  aws_account_id = var.aws_account_id != "" ? var.aws_account_id : data.aws_caller_identity.current.account_id
  name           = var.name != null ? "${var.capsule_service}-${var.name}-${var.capsule_env}" : "${var.capsule_service}-${var.capsule_env}"

  oidc_urls = [
    for cluster in data.aws_eks_cluster.this :
    {
      cluster = cluster.id
      url     = replace(cluster.identity.0.oidc.0.issuer, "https://", "")
    }
  ]

  tags = {
    terraform         = "true"
    "capsule:env"     = var.capsule_env
    "capsule:team"    = var.capsule_team
    "capsule:service" = var.capsule_service
  }
}

#######################
# OIDC Assumable Role #
#######################
data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

data "aws_eks_clusters" "this" {}

data "aws_eks_cluster" "this" {
  for_each = toset(var.cluster_names)
  name     = each.value
}

data "aws_iam_policy_document" "oidc_policy_document" {
  dynamic "statement" {
    for_each = local.oidc_urls.*.url

    content {
      effect  = "Allow"
      actions = ["sts:AssumeRoleWithWebIdentity"]

      principals {
        type        = "Federated"
        identifiers = ["arn:${data.aws_partition.current.partition}:iam::${local.aws_account_id}:oidc-provider/${statement.value}"]
      }

      dynamic "condition" {
        for_each = length(var.oidc_fully_qualified_subjects) > 0 ? local.oidc_urls : []

        content {
          test     = "StringEquals"
          variable = "${statement.value}:sub"
          values   = var.oidc_fully_qualified_subjects
        }
      }

      dynamic "condition" {
        for_each = length(var.oidc_subjects_with_wildcards) > 0 ? local.oidc_urls : []

        content {
          test     = "StringLike"
          variable = "${statement.value}:sub"
          values   = var.oidc_subjects_with_wildcards
        }
      }
    }
  }

  # additional pass-through assume-role permissions for the given AWS services
  dynamic "statement" {
    for_each = var.assume_role_for_aws_services

    content {
      effect  = "Allow"
      actions = ["sts:AssumeRole"]

      principals {
        type        = "Service"
        identifiers = [statement.value]
      }
    }
  }
}

resource "aws_iam_role" "oidc_role" {
  name                 = local.name
  description          = var.role_description
  path                 = var.role_path
  max_session_duration = 43200

  force_detach_policies = true

  assume_role_policy = data.aws_iam_policy_document.oidc_policy_document.json

  tags = local.tags
}

##################
# Service Policy #
##################
data "aws_iam_policy_document" "this_service_policy_document" {

  # enumerate all the ABAC policies
  dynamic "statement" {
    for_each = var.abac_actions
    content {

      actions = statement.value["actions"]

      resources = ["*"]
      condition {
        test     = "ForAllValues:StringEquals"
        variable = "aws:TagKeys"
        values   = ["capsule:env", "capsule:service"]
      }
      condition {
        test     = "StringEqualsIfExists"
        variable = "aws:ResourceTag/capsule:env"
        values   = ["$${aws:PrincipalTag/capsule:env}"]
      }
      condition {
        test     = "StringEqualsIfExists"
        variable = "aws:ResourceTag/capsule:service"
        values   = ["$${aws:PrincipalTag/capsule:service}"]
      }

    }
  }

  # ABAC exception (RBAC) policy for DynamoDB
  dynamic "statement" {
    for_each = var.rbac_actions_dynamodb ? [1] : []
    content {
      actions = ["dynamodb:*"]
      resources = [
        "arn:aws:dynamodb:us-east-1:${local.aws_account_id}:*${var.capsule_service}*-${var.capsule_env}*",     # bucket
        "arn:aws:dynamodb::${local.aws_account_id}:global-table/*${var.capsule_service}*-${var.capsule_env}*", # multi-region tables
      ]
    }
  }

  # ABAC exception (RBAC) policy for KafkaConnect
  dynamic "statement" {
    for_each = var.rbac_actions_kafkaconnect ? [1] : []
    content {
      actions = ["kafkaconnect:*"]
      resources = [
        "arn:aws:kafkaconnect:us-east-1:${local.aws_account_id}:*${var.capsule_service}*-${var.capsule_env}*",
      ]
    }
  }

  # ABAC exception (RBAC) policy for Lambda
  dynamic "statement" {
    for_each = var.rbac_actions_lambda ? [1] : []
    content {
      actions = ["lambda:*"]
      resources = [
        "arn:aws:lambda:us-east-1:${local.aws_account_id}:*${var.capsule_service}*-${var.capsule_env}*",
      ]
    }
  }

  # ABAC exception (RBAC) policy for s3
  dynamic "statement" {
    for_each = var.rbac_actions_s3 ? [1] : []
    content {
      actions = ["s3:*"]
      resources = [
        "arn:aws:s3:::*${var.capsule_service}*-${var.capsule_env}*",   # bucket
        "arn:aws:s3:::*${var.capsule_service}*-${var.capsule_env}*/*", # object
        "arn:aws:s3::${local.aws_account_id}:accesspoint/*",           # multi-region accesspoint
        "arn:aws:s3:us-east-1:${local.aws_account_id}:job/*",          # jobs
      ]
    }
  }

  # ABAC exception (RBAC) policy for SQS
  dynamic "statement" {
    for_each = var.rbac_actions_sqs ? [1] : []
    content {
      actions = ["sqs:*"]
      resources = [
        "arn:aws:sqs:us-east-1:${local.aws_account_id}:*${var.capsule_service}*-${var.capsule_env}*",
      ]
    }
  }

  # additional actions without Conditions
  dynamic "statement" {
    for_each = var.additional_actions
    content {
      actions   = statement.value["actions"]
      resources = statement.value["resources"]
    }
  }

  # additional actions with Conditions
  dynamic "statement" {
    for_each = var.additional_conditional_actions
    content {
      actions   = statement.value["actions"]
      resources = statement.value["resources"]
      dynamic "condition" {
        for_each = statement.value.conditions
        content {
          test     = condition.value["test"]
          variable = condition.value["variable"]
          values   = condition.value["values"]
        }
      }
    }
  }
}

resource "aws_iam_policy" "this_service_policy" {
  name        = local.name
  path        = var.role_path
  description = var.policy_description

  policy = data.aws_iam_policy_document.this_service_policy_document.json
}

resource "aws_iam_role_policy_attachment" "oidc_attachment" {
  role       = aws_iam_role.oidc_role.name
  policy_arn = aws_iam_policy.this_service_policy.arn
}
