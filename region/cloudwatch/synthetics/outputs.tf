output "id" {
  description = "The ID of the created canary"
  value       = aws_synthetics_canary.this.id
}

output "arn" {
  description = "The ARN of the created canary"
  value       = aws_synthetics_canary.this.arn
}

output "status" {
  description = "The status of the created canary"
  value       = aws_synthetics_canary.this.status
}

output "alarms" {
  description = "An array of 0 or more alarms created "
  value       = aws_cloudwatch_metric_alarm.success_percent_alert
}