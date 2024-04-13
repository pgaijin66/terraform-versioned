locals {
  name = var.name != null ? "${var.capsule_service}-${var.name}-${var.capsule_env}" : "${var.capsule_service}-${var.capsule_env}"

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

data "template_file" "_" {
  template = var.api_template_file

  vars = var.api_template_vars
}

# we will probably have to move both API Key & Usage Plans out of this module in the
# future since API keys may be used across API Gateways.

resource "aws_api_gateway_api_key" "_" {
  count = var.api_key_name != null ? 1 : 0

  name        = var.api_key_name
  description = var.api_key_description != null ? "${var.api_key_description} - Managed by Terraform" : "Managed by Terraform"
  enabled     = var.api_key_enabled
  value       = var.api_key_value

  tags = local.tags
}

# how do we export this so that people can use it?
# what's the useful output? https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_usage_plan_key

resource "aws_api_gateway_usage_plan_key" "main" {
  count = length(aws_api_gateway_api_key._) != 0 ? 1 : 0

  key_id        = aws_api_gateway_api_key._[0].id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan._[0].id
}

resource "aws_api_gateway_usage_plan" "_" {
  count = var.usage_plan_name != null ? 1 : 0

  name = "${var.capsule_service}-${var.usage_plan_name}-${var.capsule_env}"

  # future-proofing: grab all stages (even though we only instantiate one right now)
  # and apply the usage plan to them all
  api_stages {
    api_id = aws_api_gateway_rest_api._.id
    stage  = aws_api_gateway_stage.this.stage_name
  }

  dynamic "quota_settings" {
    for_each = var.quota_limit != null && var.quota_offset != null && var.quota_period != null ? [1] : []
    content {
      limit  = var.quota_limit
      offset = var.quota_offset
      period = var.quota_period
    }
  }

  dynamic "throttle_settings" {
    for_each = var.throttle_burst_limit != null && var.throttle_rate_limit != null ? [1] : []
    content {
      burst_limit = var.throttle_burst_limit
      rate_limit  = var.throttle_rate_limit
    }
  }
}

resource "aws_api_gateway_rest_api" "_" {
  name = local.name

  body = data.template_file._.rendered

  endpoint_configuration {
    types = [var.endpoint_configuration_type]
  }

  tags = local.tags
}

resource "aws_api_gateway_deployment" "_" {
  rest_api_id = aws_api_gateway_rest_api._.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api._.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

# if more stages are necessary down the road, we'll add them
# for now, this
resource "aws_api_gateway_stage" "this" {
  stage_name    = var.stage_name
  deployment_id = aws_api_gateway_deployment._.id
  rest_api_id   = aws_api_gateway_rest_api._.id

  tags = local.tags
}

# if the apigateway will invoke lambdas, we set the lambda permission to allow invocations
# https://capsule.zendesk.com/agent/tickets/83941
resource "aws_lambda_permission" "this" {
  for_each = toset(var.lambda_names)

  action        = "lambda:InvokeFunction"
  function_name = each.value
  principal     = "apigateway.amazonaws.com"

  # The /*/*/* part allows invocation from any stage, method and resource path
  # within API Gateway REST API. 
  # Specifying the stage WILL NOT WORK.
  source_arn = "${aws_api_gateway_rest_api._.execution_arn}/*/*/*"
}
