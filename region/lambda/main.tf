locals {
  function_name = var.name != null ? "${var.capsule_service}-${var.name}-${var.capsule_env}" : "${var.capsule_service}-${var.capsule_env}"

  # If we decide to add more standard managed roles to be assigned to each Lambda, please add more to this list.
  standard_managed_roles = [
    "service-role/AWSLambdaBasicExecutionRole",
  ]
  enable_read_secrets_manager = var.secrets_file != "" || length(var.read_secrets) > 0

  vanta_tags_required = contains(["production", "prod"], var.capsule_env) ? true : false

  tags = {
    terraform = "true"

    "capsule:env"     = var.capsule_env
    "capsule:team"    = var.capsule_team
    "capsule:service" = var.capsule_service

    VantaOwner            = local.vanta_tags_required ? coalesce(var.capsule_team, "VALUE REQUIRED ONLY FOR PROD") : var.capsule_team
    VantaNonProd          = local.vanta_tags_required ? false : true
    VantaDescription      = local.vanta_tags_required ? coalesce(var.vanta_description, "VALUE REQUIRED ONLY FOR PROD") : var.vanta_description
    VantaContainsUserData = local.vanta_tags_required ? var.vanta_user_data : false
    VantaUserDataStored   = local.vanta_tags_required ? coalesce(var.vanta_user_data_stored, "VALUE REQUIRED ONLY FOR PROD") : var.vanta_user_data_stored
    VantaContainsEPHI     = local.vanta_tags_required ? var.vanta_contains_ephi : false
  }
}

terraform {
  required_providers {
    sops = {
      source  = "carlpett/sops"
      version = "~> 1.0.0"
    }
  }
}

# Default permissions for the Lambda.
resource "aws_iam_role" "base_role" {
  name        = local.function_name
  description = "Role for the ${local.function_name} Lambda function - Managed by Terraform"

  force_detach_policies = true
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Effect" : "Allow",
      }
    ]
  })

  tags = local.tags
}

resource "aws_secretsmanager_secret" "lambda_secrets" {
  count = var.secrets_file != "" ? 1 : 0

  name                    = "${var.secrets_manager_path_prefix}/${local.function_name}"
  recovery_window_in_days = var.secret_recovery_window_in_days
}

data "sops_file" "secrets_file" {
  count = var.secrets_file != "" ? 1 : 0

  source_file = var.secrets_file
}

resource "aws_secretsmanager_secret_version" "lambda_secrets" {
  count = var.secrets_file != "" ? 1 : 0

  secret_id     = aws_secretsmanager_secret.lambda_secrets[count.index].name
  secret_string = data.sops_file.secrets_file[count.index].raw
}

data "aws_iam_policy_document" "secrets_manager_read" {
  count = var.secrets_file != "" || length(var.read_secrets) > 0 ? 1 : 0

  statement {
    actions = [
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecretVersionIds"
    ]
    resources = var.secrets_file != "" ? concat(var.read_secrets, [aws_secretsmanager_secret.lambda_secrets[count.index].arn]) : var.read_secrets
  }
}

resource "aws_iam_policy" "secrets_manager_read" {
  count = var.secrets_file != "" || length(var.read_secrets) > 0 ? 1 : 0

  name        = "${local.function_name}-secrets-read-policy"
  description = "Read-only secrets policy for the ${local.function_name} Lambda function - Managed by Terraform"

  policy = data.aws_iam_policy_document.secrets_manager_read[count.index].json

  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "managed_roles" {
  for_each = toset(
    concat(
      local.standard_managed_roles,
      length(var.vpc_subnets) > 0 && length(var.vpc_security_groups) > 0 ? ["service-role/AWSLambdaVPCAccessExecutionRole"] : [],
      var.enable_read_dynamodb ? ["service-role/AWSLambdaDynamoDBExecutionRole"] : [],
      var.enable_read_kinesis ? ["service-role/AWSLambdaKinesisExecutionRole"] : [],
      var.enable_read_msk ? ["service-role/AWSLambdaMSKExecutionRole"] : [],
      var.enable_read_sqs ? ["service-role/AWSLambdaSQSQueueExecutionRole"] : [],
      var.enable_write_lambda_insights ? ["CloudWatchLambdaInsightsExecutionRolePolicy"] : [],
      var.enable_read_write_s3 ? ["service-role/AmazonS3ObjectLambdaExecutionRolePolicy"] : [],
    )
  )
  role       = aws_iam_role.base_role.name
  policy_arn = "arn:aws:iam::aws:policy/${each.key}"
}

resource "aws_iam_role_policy_attachment" "secrets_read_role" {
  count = local.enable_read_secrets_manager ? 1 : 0

  role       = aws_iam_role.base_role.name
  policy_arn = aws_iam_policy.secrets_manager_read[count.index].arn
}

# Additional optional statements given by module users.
resource "aws_lambda_permission" "allow_cognito" {
  count         = var.enable_invoke_from_cognito ? 1 : 0
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function.function_name
  principal     = "cognito-idp.amazonaws.com"
  source_arn    = var.cognito_arn
}

resource "aws_iam_policy" "addtl_statements_policy" {
  count = length(var.additional_policy_statements) > 0 ? 1 : 0

  name        = "${local.function_name}-policy"
  description = "Role policy for the ${local.function_name} Lambda function - Managed by Terraform"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : var.additional_policy_statements
  })

  tags = local.tags
}

# Attach above optional statements.
resource "aws_iam_role_policy_attachment" "addtl_statements_attachment" {
  count = length(var.additional_policy_statements) > 0 ? 1 : 0

  role       = aws_iam_role.base_role.name
  policy_arn = aws_iam_policy.addtl_statements_policy[count.index].arn
}

resource "aws_lambda_function" "lambda_function" {
  function_name = local.function_name
  role          = aws_iam_role.base_role.arn

  package_type = "Image"
  image_uri    = var.image_uri

  timeout     = var.timeout
  memory_size = var.memory_size

  # From the Terraform AWS Lambda docs: If both subnet_ids and security_group_ids
  # are empty then vpc_config is considered to be empty or unset.
  vpc_config {
    # Every subnet should be able to reach an EFS mount target in the same Availability
    # Zone. Cross-AZ mounts are not permitted.
    subnet_ids         = var.vpc_subnets
    security_group_ids = var.vpc_security_groups
  }

  dynamic "environment" {
    for_each = var.env_variables != null ? [1] : []
    content {
      variables = var.env_variables
    }
  }

  # TODO - assign sns:Publish or sqs:SendMessage depending on status of dlq config
  dynamic "dead_letter_config" {
    for_each = var.dlq_target_arn != null ? [var.dlq_target_arn] : []
    content {
      target_arn = dead_letter_config.key
    }
  }

  tags = local.tags
}

resource "aws_lambda_event_source_mapping" "event_source_mapping" {
  for_each = { for k, v in var.event_source_mapping : k => v }

  event_source_arn = try(each.value.event_source_arn, null)
  function_name    = aws_lambda_function.lambda_function.arn

  batch_size                         = try(each.value.batch_size, null)
  maximum_batching_window_in_seconds = try(each.value.maximum_batching_window_in_seconds, null)
  enabled                            = try(each.value.enabled, true)
  starting_position                  = try(each.value.starting_position, null)
  starting_position_timestamp        = try(each.value.starting_position_timestamp, null)
  parallelization_factor             = try(each.value.parallelization_factor, null)
  maximum_retry_attempts             = try(each.value.maximum_retry_attempts, null)
  maximum_record_age_in_seconds      = try(each.value.maximum_record_age_in_seconds, null)
  bisect_batch_on_function_error     = try(each.value.bisect_batch_on_function_error, null)
  topics                             = try(each.value.topics, null)
  queues                             = try(each.value.queues, null)
  function_response_types            = try(each.value.function_response_types, null)

  dynamic "destination_config" {
    for_each = try(each.value.destination_arn_on_failure, null) != null ? [true] : []
    content {
      on_failure {
        destination_arn = each.value["destination_arn_on_failure"]
      }
    }
  }

  dynamic "scaling_config" {
    for_each = try([each.value.scaling_config], [])
    content {
      maximum_concurrency = try(scaling_config.value.maximum_concurrency, null)
    }
  }


  dynamic "self_managed_event_source" {
    for_each = try(each.value.self_managed_event_source, [])
    content {
      endpoints = self_managed_event_source.value.endpoints
    }
  }

  dynamic "self_managed_kafka_event_source_config" {
    for_each = try(each.value.self_managed_kafka_event_source_config, [])
    content {
      consumer_group_id = self_managed_kafka_event_source_config.value.consumer_group_id
    }
  }
  dynamic "amazon_managed_kafka_event_source_config" {
    for_each = try(each.value.amazon_managed_kafka_event_source_config, [])
    content {
      consumer_group_id = amazon_managed_kafka_event_source_config.value.consumer_group_id
    }
  }

  dynamic "source_access_configuration" {
    for_each = try(each.value.source_access_configuration, [])
    content {
      type = source_access_configuration.value["type"]
      uri  = source_access_configuration.value["uri"]
    }
  }

  dynamic "filter_criteria" {
    for_each = try(each.value.filter_criteria, null) != null ? [true] : []

    content {
      dynamic "filter" {
        for_each = try(flatten([each.value.filter_criteria]), [])

        content {
          pattern = try(filter.value.pattern, null)
        }
      }
    }
  }
}
