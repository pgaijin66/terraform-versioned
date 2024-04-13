output "name" {
  description = "The name of the Lambda function. (Required)"
  value       = aws_lambda_function.lambda_function.function_name
}

output "arn" {
  description = "Amazon Resource Name (ARN) identifying your Lambda Function."
  value       = aws_lambda_function.lambda_function.arn
}

output "invoke_arn" {
  description = "ARN to be used for invoking Lambda Function - to be used in `aws_api_gateway_integration`'s uri, among others"
  value       = aws_lambda_function.lambda_function.invoke_arn
}

output "qualified_arn" {
  description = "ARN identifying your Lambda Function Version (if versioning is enabled via publish = true)."
  value       = aws_lambda_function.lambda_function.qualified_arn
}

# TODO(rfox) this is only available on  v4.31.0 or higher of the provider; for now we're commenting this out
# but if users end up needing it for some reason or another we'll push through the effort to enable it.
# output "qualified_invoke_arn" {
#   description = "ARN for invoking your Lambda Function Version (if versioning is enabled via publish = true)."
#   value       = aws_lambda_function.lambda_function.qualified_invoke_arn
# }

output "signing_job_arn" {
  description = "ARN of the signing job."
  value       = aws_lambda_function.lambda_function.signing_job_arn
}

output "version" {
  description = "Latest published version of your Lambda Function."
  value       = aws_lambda_function.lambda_function.version
}
