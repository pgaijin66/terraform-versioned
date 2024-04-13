variable "name" {
  type        = string
  default     = null
  description = "The name to give the dynamodb table that you want to create"
}

variable "legacy_name" {
  type        = string
  default     = null
  description = "Will be deprecated. Do not use this value, for pre-existing legacy tables only."
}

variable "hash_key" {
  type        = string
  description = "This is also known as the partition key and is required by dynamodb as the primary key"
}

variable "hash_key_type" {
  type        = string
  default     = "S"
  description = "Specify the hash key type. Options are (S)tring, (N)umber or (B)inary data. Defaults to 'S'."
}

variable "range_key" {
  type        = string
  default     = null
  description = "DynamoDB table Range Key"
}

variable "range_key_type" {
  type        = string
  default     = "S"
  description = "Specify the range key type. Options are (S)tring, (N)umber or (B)inary data. Defaults to 'S'."
}

variable "attributes" {
  type = list(object({
    name = string
    type = string
  }))
  default     = []
  description = "Additional DynamoDB attributes in the form of a list of mapped values"
}

variable "global_secondary_indices" {
  type = list(object({
    name               = string
    hash_key           = string
    range_key          = optional(string)
    write_capacity     = optional(number)
    read_capacity      = optional(number)
    projection_type    = string
    non_key_attributes = optional(list(string))
  }))
  default     = []
  description = "Additional DynamoDB attributes in the form of a list of mapped values"
}

variable "billing_mode" {
  type        = string
  default     = "PAY_PER_REQUEST"
  description = "DynamoDB Billing mode. Can be PROVISIONED or PAY_PER_REQUEST. Defaults to 'PAY_PER_REQUEST'."
}

variable "read_capacity" {
  type        = number
  default     = 5
  description = "DynamoDB read capacity"
}

variable "write_capacity" {
  type        = number
  default     = 5
  description = "DynamoDB write capacity"
}

variable "enable_encryption" {
  type        = bool
  default     = true
  description = "Enable DynamoDB server-side encryption"
}

variable "encryption_kms_key_arn" {
  type        = string
  default     = null
  description = "The ARN of the KMS encryption key. Defaults to 'alias/aws/dynamodb'."
}

variable "ttl_attribute" {
  type        = string
  default     = "Expires"
  description = "DynamoDB table TTL attribute"
}

variable "ttl_enabled" {
  type        = bool
  default     = false
  description = "Whether to enable the ttl attribute for items in the table."
}

variable "capsule_team" {
  description = "The name of the Capsule team that this resource will be associated with"
  type        = string
}

variable "capsule_service" {
  description = "The name of the Capsule service that this resource will be associated with"
  type        = string
}

variable "capsule_env" {
  description = "The Capsule environment that this resource will be deployed into (dev, staging, production)"
  type        = string
}

variable "vanta_owner" {
  description = "Vanta specific tag to identify resource owner"
  type        = string
  default     = "Global"
}

variable "vanta_nonprod" {
  description = "Vanta specific tag to if resource is non-prod"
  type        = bool
  default     = false
}

variable "vanta_description" {
  description = "Vanta specific tag to specify the purpose of resource"
  type        = string
  default     = "DynamoDB Service"
}

variable "vanta_user_data" {
  description = "Vanta specific tag to specify if the resource will contain user data"
  type        = bool
  default     = false

}

variable "vanta_user_data_stored" {
  description = "Vanta specific tag to specify the type of data the resource transacts/stores"
  type        = string
  default     = "Stored Account Information"
}

variable "vanta_contains_ephi" {
  description = "Vanta specific tag to specify if the resource contains electronic protected health information (ePHI)"
  type        = bool
  default     = false
}
