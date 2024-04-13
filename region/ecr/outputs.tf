output "name" {
  description = "The name of the created repository"
  value       = aws_ecr_repository.this.name
}
output "arn" {
  description = "The ARN of the created repository"
  value       = aws_ecr_repository.this.arn
}

output "registry_id" {
  description = "The registry ID for the created repository"
  value       = aws_ecr_repository.this.registry_id
}

output "repository_url" {
  description = "The URL of the created repository"
  value       = aws_ecr_repository.this.repository_url
}
