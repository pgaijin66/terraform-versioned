resource "aws_cloudwatch_log_group" "this" {
  name = var.name
  tags = var.tags
}

data "aws_iam_policy_document" "es_log_publishing_policy" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:PutLogEventsBatch",
    ]

    resources = [aws_cloudwatch_log_group.this.arn]

    principals {
      identifiers = ["es.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_cloudwatch_log_resource_policy" "es_log_publishing_policy" {
  policy_document = data.aws_iam_policy_document.es_log_publishing_policy.json
  policy_name     = "${var.name}-log-publishing-policy"
}
