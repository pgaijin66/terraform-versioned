locals {
  name        = var.name != null ? "${var.capsule_service}-${var.capsule_env}-${var.name}" : "${var.capsule_service}-${var.capsule_env}"
  name_substr = substr(local.name, 0, 16)
  helm_name   = length(local.name) > 38 ? substr(local.name, 0, 37) : local.name
  alarm_name  = "[${var.capsule_team}/${var.capsule_service}/${var.capsule_env}] SyntheticsCanary${var.name != null ? " ${var.name}" : ""} SuccessPercent less than 90"
  is_prod_aws = contains(["staging", "production"], var.capsule_env)
  aws_account = local.is_prod_aws ? "874873923888" : "036483606784"
  tags = {
    terraform         = "true"
    "capsule:env"     = var.capsule_env
    "capsule:team"    = var.capsule_team
    "capsule:service" = var.capsule_service
  }
}

// Data Sources
data "aws_vpc" "vpc_internal" {
  tags = {
    Name = local.is_prod_aws ? "vpc-internal" : "vpc-${var.capsule_env}"
  }
}

data "aws_subnet_ids" "private_vpc_internal_subnets" {
  vpc_id = data.aws_vpc.vpc_internal.id

  filter {
    name = "tag:Name"
    values = [
      local.is_prod_aws ? "vpc-internal-private*" : "vpc-${var.capsule_env}-private*"
    ]
  }
}

data "aws_s3_bucket" "capsule_canary_code" {
  bucket = local.is_prod_aws ? "capsule-canary-code" : "capsule-canary-code-dev"
}

// Resources
resource "random_id" "name_hash" {
  byte_length = 2
}

resource "aws_s3_bucket_object" "canary_code" {
  key                    = "${local.name}.zip"
  bucket                 = data.aws_s3_bucket.capsule_canary_code.id
  source                 = "${local.name}.zip"
  server_side_encryption = "AES256"
  etag                   = filemd5("${local.name}.zip")
}

resource "aws_synthetics_canary" "this" {
  name                 = join("-", [local.name_substr, random_id.name_hash.hex])
  artifact_s3_location = "s3://cw-syn-results-${local.aws_account}-us-east-1/canary/${local.name}"
  execution_role_arn   = "arn:aws:iam::${local.aws_account}:role/cloudwatch-synthetics-catchall"
  handler              = var.handler
  start_canary         = true
  s3_bucket            = data.aws_s3_bucket.capsule_canary_code.bucket
  s3_key               = aws_s3_bucket_object.canary_code.key
  s3_version           = aws_s3_bucket_object.canary_code.version_id
  runtime_version      = var.runtime_version

  schedule {
    expression = var.minutes == 1 ? "rate(1 minute)" : "rate(${var.minutes} minutes)"
  }

  run_config {
    active_tracing     = var.runtime_version == "syn-nodejs-puppeteer-3.1" ? true : false
    timeout_in_seconds = var.minutes * 60
  }

  dynamic "vpc_config" {
    # if var.private_endpoint is false, dont create anything. If it's not false, create exactly one block ([1]).
    for_each = var.private_endpoint == false ? [] : [1]

    content {
      # can only have 16 subnets associated. We have more private subnets than that. This is a very ugly way of making sure we only use 16
      subnet_ids         = slice(tolist(data.aws_subnet_ids.private_vpc_internal_subnets.ids), 0, min(15, length(tolist(data.aws_subnet_ids.private_vpc_internal_subnets.ids))))
      security_group_ids = local.is_prod_aws ? ["sg-0a27e251102b6a51e"] : ["sg-04dc161f4e852ea9b"]
    }
  }

  tags = merge(local.tags, {
    Name = local.name
  })
}

// Cloudwatch Alarm
resource "aws_cloudwatch_metric_alarm" "success_percent_alert" {
  count = var.alert_on_failure ? 1 : 0

  alarm_name = local.alarm_name

  namespace           = "CloudWatchSynthetics"
  metric_name         = "SuccessPercent"
  statistic           = "Sum"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = var.alarm_evaluation_periods

  period              = var.alarm_period_seconds
  threshold           = var.alarm_threshold
  datapoints_to_alarm = var.alarm_num_datapoints_to_alarm

  dimensions = {
    CanaryName = aws_synthetics_canary.this.id
  }

  ok_actions    = [var.alert_queue]
  alarm_actions = [var.alert_queue]

}

// Secrets Manager
resource "aws_secretsmanager_secret" "canary_secret" {
  count = var.secret_value != null ? 1 : 0
  name  = "synthetics-${local.name}"

  recovery_window_in_days = var.secret_recovery_window_in_days

  tags = merge(local.tags, {
    Name = "synthetics-${local.name}"
  })
}

resource "aws_secretsmanager_secret_version" "canary_secret" {
  count         = var.secret_value != null ? 1 : 0
  secret_id     = aws_secretsmanager_secret.canary_secret[count.index].id
  secret_string = var.secret_value
}

// YACE
data "sops_file" "secrets" {
  source_file = "${path.module}/secrets.yaml"
}

resource "null_resource" "clean_up" {
  depends_on = [
    aws_synthetics_canary.this
  ]
  triggers = {
    name = join("-", [local.name_substr, random_id.name_hash.hex])
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<-EOD
export CANARY_ID=$(aws synthetics get-canary --name=${self.triggers.name} --query 'Canary.Id'| sed -e 's/^"//' -e 's/"$//')
aws logs delete-log-group --log-group-name="/aws/lambda/cwsyn-${self.triggers.name}-$CANARY_ID"
aws lambda delete-function --function-name=cwsyn-${self.triggers.name}-$CANARY_ID
for i in $(aws lambda list-layer-versions --layer-name=cwsyn-${self.triggers.name}-$CANARY_ID --query 'to_array(LayerVersions[*].Version)' --output text); do aws lambda delete-layer-version --layer-name cwsyn-${self.triggers.name}-$CANARY_ID --version-number $i; done
EOD
  }
}
