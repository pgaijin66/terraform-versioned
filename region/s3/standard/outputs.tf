output "id" {
  description = "The name of the created bucket"
  value       = aws_s3_bucket.this.id
}

output "arn" {
  description = "The ARN of the created bucket"
  value       = aws_s3_bucket.this.arn
}

output "bucket_domain_name" {
  description = "The bucket domain name of the created bucket"
  value       = aws_s3_bucket.this.bucket_domain_name
}

output "bucket_regional_domain_name" {
  description = "The bucket region-specific domain name of the created bucket"
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}
