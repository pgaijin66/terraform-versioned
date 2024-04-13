variable "name" {
  type        = string
  description = "Name of the SNS topic to create"
}

variable "fifo_topic" {
  type        = bool
  default     = false
  description = "Whether the topic created should be FIFO"
}

variable "content_based_deduplication" {
  type        = bool
  default     = false
  description = "Whether to enable content-based deduplication for FIFO topics "
}

variable "sqs_queue_subscriptions" {
  type = map(object({
    arn                  = string
    raw_message_delivery = bool
    filter_policy        = optional(string)
  }))
  default     = {}
  description = "Map of SQS queue ARNs to subscribe to the SNS topic. Raw message delivery needs to be set per queue"
}

variable "kms_key_id" {
  description = "The ID of an AWS-managed customer master key (CMK) for Amazon SNS or a custom CMK. We highly recommend not changing this value"
  type        = string
  default     = "alias/sns-sqs"
}

variable "capsule_team" {
  description = "The name of the team that this bucket will be associated with"
  type        = string
}

variable "capsule_service" {
  description = "The name of the service that this bucket will be associated with"
  type        = string
}

variable "capsule_env" {
  description = "The environment that this bucket will be deployed into (dev, staging, production)"
  type        = string
}

variable "vanta_owner" {
  description = "Vanta specific tag to identify resource owner - string"
  type        = string
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
