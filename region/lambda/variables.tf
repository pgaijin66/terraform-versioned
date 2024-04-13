variable "name" {
  type        = string
  description = "The name of the Lambda function. (Required)"
}

variable "image_uri" {
  type        = string
  description = "The ECR image URI to pull and use. (Required)"
}

variable "memory_size" {
  type        = number
  description = "The amount of memory to assign the Lambda in MB. Must be greater than 128. (Default: 128)"
  default     = 128
}

variable "timeout" {
  type        = number
  description = "The amount of time the Lambda has to run the function in seconds. (Default: 3)"
  default     = 3
}

variable "env_variables" {
  type        = map(any)
  description = "A map of environment variables for the Lambda in K,V format"
  default     = null
}

variable "additional_policy_statements" {
  type        = any
  description = "A list of additional policy statements to attach to the base role. Statements should be in Terraform map format (e.g. {Action = [], Effect = 'Allow', Resource = '*'})"
  default     = []
}

variable "event_source_mapping" {
  type        = any
  description = "Enables the creation of an event source mapping for this Lambda."
  default     = {}
}

## ---------------
## VPC variables
## ---------------
variable "vpc_subnets" {
  type        = list(string)
  description = "List of subnet IDs associated with the Lambda function."
  default     = []
}

variable "vpc_security_groups" {
  type        = list(string)
  description = "List of security group IDs associated with the Lambda function."
  default     = []
}


## ---------------
## Miscellaneous Permissions variables
## ---------------
variable "enable_read_dynamodb" {
  type        = bool
  description = "Grants the permissions for the Lambda to read from DyanamoDB. (Default: false)"
  default     = false
}

variable "enable_read_kinesis" {
  type        = bool
  description = "Grants the permissions for the Lambda to read from Kinesis. (Default: false)"
  default     = false
}

variable "enable_read_msk" {
  type        = bool
  description = "Grants the permissions for the Lambda to read from MSK. (Default: false)"
  default     = false
}

variable "enable_read_sqs" {
  type        = bool
  description = "Grants the permissions for the Lambda to read from SQS. (Default: false)"
  default     = false
}

variable "enable_write_lambda_insights" {
  type        = bool
  description = "Grants the permissions for the Lambda to write to Lambda Insights. (Default: false)"
  default     = false
}

variable "enable_read_write_s3" {
  type        = bool
  description = "Grants the permissions for the Lambda to read and write to and from S3. (Default: false)"
  default     = false
}

variable "enable_invoke_from_cognito" {
  type        = bool
  description = "Allows the role created for this Lambda to be invoked by Cognito. Only useful if you're going to be using this Lambda as part of a Cognito userpool. (Default: false)"
  default     = false
}

variable "cognito_arn" {
  type        = string
  description = "If enable_invoke_from_cognito is true, this is the ARN or ARN-pattern to allow to invoke this Lambda. (Without it, ANY Cognito userpool in ANY account could invoke this Lambda.)"
  default     = ""
}

### --------------
## Secrets management variables
### --------------

variable "secrets_manager_path_prefix" {
  type        = string
  description = "Specifies the prefix under which Secrets Manager secrets will be created. (Default: no value -> will prefix secrets with 'lambda/[name of Lambda]/'."
  default     = "lambda"
}

variable "secrets_file" {
  type        = string
  description = "Relative path to `sops`-encrypted JSON file containing secrets to create for this Lambda. (Default: '')"
  default     = ""
}

variable "secret_recovery_window_in_days" {
  type        = number
  description = "Number of days that this Lambda's secrets (if any) will be recoverable if deleted. (Default: 30)"
  default     = 30
}

variable "read_secrets" {
  type        = list(string)
  description = "List of ARNs for existing Secrets Manager secrets the Lambda will be able to read. (Default: [])"
  default     = []
}

## ---------------
## DLQ Publishing variables
## ---------------
variable "dlq_target_arn" {
  type        = string
  description = "The ARN of the dead-letter SNS/SQS queue to target."
  default     = null
}

## ---------------
## Capsule metadata variables
## ---------------
variable "capsule_service" {
  type        = string
  description = "The service that this Lambda belongs to. (Required)"
}

variable "capsule_env" {
  type        = string
  description = "The environment that the Lambda belongs to. (Required)"
}

variable "capsule_team" {
  type        = string
  description = "The team that the Lambda belongs to. (Required)"
}

## ---------------
## Vanta variables
## ---------------
variable "vanta_description" {
  type        = string
  description = "Vanta specific tag to specify the purpose of resource - string value (Required)"
}

variable "vanta_user_data" {
  type        = bool
  description = "Vanta specific tag to specify if the resource will contain user data - true or false (Required)"
}

variable "vanta_user_data_stored" {
  type        = string
  description = "Vanta specific tag to specify the type of data the resource transacts/stores - string value (Required)"
}

variable "vanta_contains_ephi" {
  type        = bool
  description = "Vanta specific tag to specify if the resource contains PHI - true or false (Required)"
}
