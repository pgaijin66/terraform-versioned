variable "bucket_name" {
  description = "The name to give to the bucket"
  type        = string
}

variable "access" {
  description = "The access level for the bucket"
  type        = string
  default     = "private"
}

variable "grants" {
  description = "The ACL grants for the bucket"
  type        = list(any)
  default     = []
}

variable "cors_rule" {
  description = "List of CORS rules. Should be a list of maps. allowed_methods and allowed_origins is required per rule"
  type        = list(any)
  default     = []
}

variable "bucket_policy" {
  description = "The policy to attach to the bucket"
  type        = string
  default     = null
}

variable "versioning" {
  description = "Specifies if versioning should be enabled or not"
  type        = bool
  default     = "true"
}

variable "lifecycle_rule" {
  description = "Collection of lifecycle rules for objects in s3 bucket"
  type        = list(any)
  default     = []
}

variable "capsule_env" {
  description = "The environment that this bucket will be deployed into (dev, staging, production)"
  type        = string
}

variable "capsule_team" {
  description = "The name of the team that this bucket will be associated with"
  type        = string
}

variable "capsule_service" {
  description = "The name of the service that this bucket will be associated with"
  type        = string
}

#--------------#
#  vanta_tags  #
#--------------#

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
  default     = "S3 Service"
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
