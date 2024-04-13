locals {
  name       = var.legacy_name != null ? var.legacy_name : (var.name != null ? "${var.capsule_service}-${var.name}-${var.capsule_env}" : "${var.capsule_service}-${var.capsule_env}")
  queue_name = var.fifo_queue ? "${local.name}.fifo" : local.name
  dlq_name   = var.fifo_queue ? "${local.name}-dlq.fifo" : "${local.name}-dlq"

  vanta_tags_required = contains(["production", "prod"], var.capsule_env) ? true : false
  tags = {
    terraform             = "true"
    "capsule:env"         = var.capsule_env
    "capsule:team"        = var.capsule_team
    "capsule:service"     = var.capsule_service
    VantaOwner            = var.vanta_owner != null ? var.vanta_owner : var.capsule_team
    VantaNonProd          = local.vanta_tags_required ? false : true
    VantaDescription      = var.vanta_description
    VantaContainsUserData = var.vanta_user_data
    VantaUserDataStored   = var.vanta_user_data_stored
    VantaContainsEPHI     = var.vanta_contains_ephi
  }
}

data "aws_caller_identity" "current" {}

resource "aws_sqs_queue" "this" {
  name                              = local.queue_name
  kms_master_key_id                 = var.kms_key_id
  kms_data_key_reuse_period_seconds = 300
  fifo_queue                        = var.fifo_queue
  content_based_deduplication       = var.content_based_deduplication
  message_retention_seconds         = var.message_retention_seconds
  visibility_timeout_seconds        = var.visibility_timeout_seconds
  redrive_policy = var.redrive_policy_enabled == true && (var.create_dlq || var.dlq_arn != null) ? jsonencode({
    deadLetterTargetArn = var.dlq_arn != null ? var.dlq_arn : aws_sqs_queue.dlq[0].arn
    # TODO: remove var.maxReceiveCount in the future, for now, if var.maxReceiveCount
    # is unset, please use var.max_receive_count
    maxReceiveCount = var.maxReceiveCount != null ? var.maxReceiveCount : var.max_receive_count
  }) : ""

  tags = merge(local.tags, {
    Name = local.queue_name
  })
}

resource "aws_sqs_queue" "dlq" {
  count                             = var.create_dlq ? 1 : 0
  name                              = local.dlq_name
  kms_master_key_id                 = var.kms_key_id
  kms_data_key_reuse_period_seconds = 300
  fifo_queue                        = var.fifo_queue
  content_based_deduplication       = var.dlq_content_based_deduplication
  message_retention_seconds         = var.dlq_message_retention_seconds
  redrive_allow_policy = var.redrive_policy_enabled == true ? jsonencode({
    # referencing the queue above creates a cycle and is a known bug
    # see https://github.com/hashicorp/terraform-provider-aws/issues/22577
    # so we manually construct the ARN here
    sourceQueueArns   = ["arn:aws:sqs:us-east-1:${data.aws_caller_identity.current.account_id}:${local.queue_name}"]
    redrivePermission = "byQueue"
  }) : ""

  tags = merge(local.tags, {
    Name = local.dlq_name
  })
}

data "aws_iam_policy_document" "allow_sns_to_send_messages" {
  statement {
    actions = [
      "sqs:SendMessage",
    ]
    principals {
      type        = "Service"
      identifiers = ["sns.amazonaws.com"]
    }
    resources = [
      aws_sqs_queue.this.arn,
    ]
    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values = concat([
        "arn:aws:sns:us-east-1:${data.aws_caller_identity.current.account_id}:${var.capsule_service}*${var.capsule_env}*"
        ],
      var.sns_topics)
    }
  }
}

resource "aws_sqs_queue_policy" "allow_sns_to_send_messages" {
  count     = var.sns_target ? 1 : 0
  queue_url = aws_sqs_queue.this.id
  policy    = data.aws_iam_policy_document.allow_sns_to_send_messages.json
}

data "aws_iam_policy_document" "lambda_interaction_policy" {
  count = var.lambda_policy == true ? 1 : 0
  statement {
    actions = [
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl",
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
    ]
    principals {
      type        = "AWS"
      identifiers = var.lambda_function_roles
    }
    resources = toset([aws_sqs_queue.this.arn])
  }
}

resource "aws_sqs_queue_policy" "lambda_interaction_policy" {
  count     = var.lambda_policy == true ? 1 : 0
  queue_url = aws_sqs_queue.this.id
  policy    = data.aws_iam_policy_document.lambda_interaction_policy[count.index].json
}
