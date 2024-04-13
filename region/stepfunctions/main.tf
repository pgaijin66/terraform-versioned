locals {
  # if we want to make this easier to mess with later on down the road....
  # not convinced this indirection is necessary but it's consistency?
  aws_account_id = data.aws_caller_identity.current.account_id
  sfn_name       = "${var.name}-${var.capsule_env}-sfn"
  role_name      = "${local.sfn_name}-role"

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

# Used in interpolation and determining who we are
data "aws_caller_identity" "current" {}

resource "aws_iam_role" "role_for_step_function" {
  name               = local.role_name
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.sfn_assume_role_policy.json
}

resource "aws_iam_role_policy" "sfn_role_policy" {
  role = aws_iam_role.role_for_step_function.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action   = ["lambda:InvokeFunction"]
      Effect   = "Allow"
      Resource = var.lambda_arns
      }, {
      Action = [
        "logs:CreateLogDelivery",
        "logs:GetLogDelivery",
        "logs:UpdateLogDelivery",
        "logs:DeleteLogDelivery",
        "logs:ListLogDeliveries",
        "logs:PutLogEvents",
        "logs:PutResourcePolicy",
        "logs:DescribeResourcePolicies",
        "logs:DescribeLogGroups"
      ]
      Effect = "Allow"
      Resource = [
        # I have tried and tried to find some way to limit this to a certain resource, but I get this error:
        # [2022-11-26T00:32:18.827Z] Error: creating Step Functions State Machine (test_sfn-test-sfn): AccessDeniedException: The state machine IAM Role is not authorized to access the Log Destination
        # every time i try to do it. Perhaps one of these Actions can't be scoped. I haven't found the time to invest in fixing it.
        # "arn:aws:logs:us-east-1:${local.aws_account_id}:log-group:/aws/vendedlogs/states/*"
        "*"
      ]
    }]
  })
}

# https://docs.aws.amazon.com/step-functions/latest/dg/procedure-create-iam-role.html#prevent-cross-service-confused-deputy
data "aws_iam_policy_document" "sfn_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["states.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [local.aws_account_id]
    }

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      # TODO: does this support wildcard on the left * (the regions) or will this break?
      values = ["arn:aws:states:*:${local.aws_account_id}:stateMachine:*"]
    }
  }
}


resource "aws_cloudwatch_log_group" "logs" {
  name              = "/aws/vendedlogs/states/${local.sfn_name}"
  retention_in_days = var.step_function_logging_retention_in_days
}

data "template_file" "definition" {
  template = file(var.definition_template_file)

  vars = var.definition_template_vars
}

resource "aws_sfn_state_machine" "this" {
  name       = local.sfn_name
  role_arn   = aws_iam_role.role_for_step_function.arn
  definition = data.template_file.definition.rendered
  type       = var.step_function_workflow_type

  # How configurable SHOULD this be? Do we want logs into CW Logs? Do we want to set up some kind of exporter to get these logs into Loki instead?
  # Do we need these logs around for compliance whatever?
  # logging_configuration {
  #   include_execution_data - (Optional) Determines whether execution data is included in your log. When set to false, data is excluded.
  #   level - (Optional) Defines which category of execution history events are logged. Valid values: ALL, ERROR, FATAL, OFF
  #   log_destination - (Optional) Amazon Resource Name (ARN) of a CloudWatch log group. Make sure the State Machine has the correct IAM policies for logging. The ARN must end with :*
  # }
  # We don't support X-ray for most services -- should we here?
  tracing_configuration {
    enabled = false
  }

  logging_configuration {
    include_execution_data = var.step_function_logging_include_execution_data
    level                  = var.step_function_logging_level
    log_destination        = "${aws_cloudwatch_log_group.logs.arn}:*"
  }

  tags = local.tags
}
