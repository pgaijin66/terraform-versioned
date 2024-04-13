output "domain_arn" {
  value       = aws_elasticsearch_domain.this.arn
  description = "ARN of the Elasticsearch domain"
}

output "domain_id" {
  value       = aws_elasticsearch_domain.this.domain_id
  description = "Unique identifier for the Elasticsearch domain"
}

output "domain_name" {
  value       = aws_elasticsearch_domain.this.domain_name
  description = "Name of the Elasticsearch domain"
}
