output "sqs_queue_id" {
  value = aws_sqs_queue.this.id
}

output "sqs_queue_arn" {
  value = aws_sqs_queue.this.arn
}

output "sqs_dlq_id" {
  value = aws_sqs_queue.dlq[*].id
}

output "sqs_dlq_arn" {
  value = aws_sqs_queue.dlq[*].arn
}
