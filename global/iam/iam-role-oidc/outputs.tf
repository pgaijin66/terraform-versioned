output "oidc_role_arn" {
  value       = aws_iam_role.oidc_role.arn
  description = "ARN of the oidc role created by this module"
}

output "oidc_role_name" {
  value       = aws_iam_role.oidc_role.name
  description = "Name of the OIDC role created by this module"
}

output "policy_arn" {
  value       = aws_iam_policy.this_service_policy.arn
  description = "ARN of the policy created by this module for accessing resources"
}

output "policy_name" {
  value       = aws_iam_policy.this_service_policy.name
  description = "Name of the policy created by this module for accessing resources"
}

output "policy" {
  value       = aws_iam_policy.this_service_policy.policy
  description = "The policy document (JSON)"
}
