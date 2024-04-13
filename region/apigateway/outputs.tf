output "deployment_id" {
  description = "Deployment id"
  value       = aws_api_gateway_deployment._.id
}

output "deployment_invoke_url" {
  description = "Deployment invoke url"
  value       = aws_api_gateway_deployment._.invoke_url
}

output "deployment_execution_arn" {
  description = "Deployment execution ARN"
  value       = aws_api_gateway_deployment._.execution_arn
}

output "rest_api_name" {
  description = "API Gateway name"
  value       = aws_api_gateway_rest_api._.name
}

output "rest_api_id" {
  description = "API Gateway id"
  value       = aws_api_gateway_rest_api._.id
}

output "usage_plan_api_key_id" {
  description = "Usage plan API Key ID"
  value       = length(aws_api_gateway_api_key._) != 0 ? aws_api_gateway_api_key._[0].id : null
}
