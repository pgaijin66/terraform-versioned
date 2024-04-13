###############################
### Grafana Cloudwatch Read ###
###############################
# -- Assume Role Policy
data "aws_iam_policy_document" "grafana_cloudwatch_read_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "AWS"
      identifiers = var.grafana_roles
    }
  }
}

# -- Role
resource "aws_iam_role" "grafana_cloudwatch_read" {
  name                 = local.name
  path                 = "/"
  max_session_duration = 43200
  assume_role_policy   = data.aws_iam_policy_document.grafana_cloudwatch_read_assume_role.json

  tags = local.tags
}

# -- Policy
data "aws_iam_policy_document" "grafana_cloudwatch_read" {
  statement {
    sid    = "AllowReadingMetricsFromCloudWatch"
    effect = "Allow"
    actions = [
      "cloudwatch:DescribeAlarmsForMetric",
      "cloudwatch:DescribeAlarmHistory",
      "cloudwatch:DescribeAlarms",
      "cloudwatch:ListMetrics",
      "cloudwatch:GetMetricData",
      "cloudwatch:GetInsightRuleReport"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "AllowReadingLogsFromCloudWatch"
    effect = "Allow"
    actions = [
      "logs:DescribeLogGroups",
      "logs:GetLogGroupFields",
      "logs:StartQuery",
      "logs:StopQuery",
      "logs:GetQueryResults",
      "logs:GetLogEvents"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "AllowReadingTagsInstancesRegionsFromEC2"
    effect = "Allow"
    actions = [
      "ec2:DescribeTags",
      "ec2:DescribeInstances",
      "ec2:DescribeRegions"
    ]
    resources = ["*"]
  }

  statement {
    sid       = "AllowReadingResourcesForTags"
    effect    = "Allow"
    actions   = ["tag:GetResources"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "grafana_cloudwatch_read" {
  name   = "grafana-cloudwatch-read"
  path   = "/"
  policy = data.aws_iam_policy_document.grafana_cloudwatch_read.json

  tags = local.tags
}

# -- Policy Attachment
resource "aws_iam_role_policy_attachment" "grafana_cloudwatch_read" {
  role       = aws_iam_role.grafana_cloudwatch_read.name
  policy_arn = aws_iam_policy.grafana_cloudwatch_read.arn
}
