output "arn" {
  description = "AWS Step Function State Machine arn"
  value       = aws_sfn_state_machine.this.arn
}
output "name" {
  description = "AWS Step Function State Machine name"
  value       = aws_sfn_state_machine.this.name
}