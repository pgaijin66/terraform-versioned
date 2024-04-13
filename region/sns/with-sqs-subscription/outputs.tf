output "sns_topic_id" {
  value = aws_sns_topic.this.id
}

output "sns_topic_arn" {
  value = aws_sns_topic.this.arn
}

output "sns_topic_subscriptions" {
  value       = aws_sns_topic_subscription.this
  description = "SNS topic subscriptions"
}
