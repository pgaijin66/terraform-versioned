variable "bucket_name" {
  description = "The name to give to the bucket"
  type        = string
}

variable "website_index_document" {
  description = "The file S3 should return when calls are made to the root domain, or subfolders"
  type        = string
  default     = "index.html"
}

variable "website_error_document" {
  description = "The file S3 should return when a 4xx error is encountered"
  type        = string
  default     = null
}

variable "website_routing_rules" {
  description = "An array of routing rules for redirect behaviors"
  type        = string
  default     = null
}

variable "website_redirect_all_requests_to" {
  description = "A host to redirect all requests to. If set, the website_index_document variable will not be used"
  type        = string
  default     = null
}

variable "cors_rule" {
  description = "List of CORS rules. Should be a list of maps. allowed_methods and allowed_origins is required per rule"
  type        = any
  default     = []
}

variable "bucket_policy" {
  description = "The policy to attach to the bucket"
  type        = string
  default     = null
}

variable "replication_configuration_role" {
  description = "An AWS Identity and Access Management (IAM) role that Amazon S3 can assume to replicate objects on your behalf"
  type        = string
  default     = null
}

variable "replication_configuration_rule" {
  description = "A list of maps for replication_configuration rules."
  type        = any
  default     = []
}

#----------------#
#  capsule tags  #
#----------------#

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
