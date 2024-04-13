variable "name" {
  description = "Optional identifier - if specified, will be interpolated into the queue name."
  type        = string
  default     = null
}

variable "legacy_name" {
  type        = string
  default     = null
  description = "Do not use this for new resources, it is reserved for legacy resources that are being migrated, and will be deprecated in the future."
}

variable "fifo_queue" {
  description = "Whether or not to create a FIFO queue."
  type        = bool
  default     = false
}

variable "content_based_deduplication" {
  description = "Whether or not to enable contest based deduplication."
  type        = bool
  default     = false
}

variable "message_retention_seconds" {
  description = "The amount of seconds to retain a message."
  type        = number
  default     = 86400 # 1 day
}

variable "visibility_timeout_seconds" {
  description = "The visibility timeout for the queue."
  type        = number
  default     = 30
}

variable "dlq_content_based_deduplication" {
  description = "Whether or not to enable contest based deduplication for the DLQ."
  type        = bool
  default     = false
}

variable "dlq_message_retention_seconds" {
  description = "The amount of seconds to retain a message in the DLQ."
  type        = number
  default     = 86400 # 1 day
}

variable "dlq_arn" {
  description = "If using an extant DLQ, or one defined by another module, the ARN of the DLQ. If provided, will be used instead of create_dlq."
  type        = string
  default     = null
}

variable "redrive_policy_enabled" {
  description = "Whether or not this queue will allow redrive to a DLQ."
  type        = bool
  default     = false
}

variable "create_dlq" {
  description = "Whether to create a DLQ alongside this SQS queue."
  type        = bool
  default     = false
}

# TODO: incorrectly formatted variable, please deprecate
variable "maxReceiveCount" {
  description = "How many times a message will be processed before being moved into the DLQ."
  type        = number
  default     = null
}

variable "max_receive_count" {
  description = "How many times a message will be processed before being moved into the DLQ."
  type        = number
  default     = 1
}

variable "sns_target" {
  description = "Whether this queue will be used as a subscription for an SNS topic."
  type        = bool
  default     = false
}
variable "capsule_env" {
  description = "The environment this queue belongs to (dev, staging, production)."
  type        = string
}

variable "capsule_team" {
  description = "The team that owns this SQS queue."
  type        = string
}

variable "capsule_service" {
  description = "The service that owns this SQS queue."
  type        = string
}

variable "sns_topics" {
  description = "List of SNS topic ARNs that are allowed to publish to this queue"
  type        = list(string)
  default     = []
}

variable "kms_key_id" {
  description = "The ID of an AWS-managed customer master key (CMK) for Amazon SQS or a custom CMK. We highly recommend not changing this value."
  type        = string
  default     = "alias/sns-sqs"
}

variable "vanta_owner" {
  description = "Vanta specific tag to identify resource owner - string"
  type        = string
}

variable "vanta_nonprod" {
  description = "Vanta specific tag to if resource is non-prod - true or false"
  type        = bool
}

variable "vanta_description" {
  description = "Vanta specific tag to specify the purpose of resource - string value"
  type        = string
}

variable "vanta_user_data" {
  description = "Vanta specific tag to specify if the resource will contain user data - true or false"
  type        = bool
}

variable "vanta_user_data_stored" {
  description = "Vanta specific tag to specify the type of data the resource transacts/stores - string value"
  type        = string
}

variable "vanta_contains_ephi" {
  description = "Vanta specific tag to specify if the resource contains PHI - true or false"
  type        = bool
}

variable "lambda_policy" {
  description = "Whether or not to create a policy for lambda functions to interact with this queue."
  type        = bool
  default     = false
}

variable "lambda_function_roles" {
  description = "List of Lambda execution roles to be added to the sqs queue policy"
  type        = list(string)
  default     = null
}
