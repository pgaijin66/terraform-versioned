variable "capsule_env" {
  description = "Name of the environment that this DB relates to. Used for the `capsule:environment` tag."
  type        = string
}

variable "capsule_team" {
  description = "Name of the team that this DB relates to. Used for the `capsule:team` tag."
  type        = string
}

variable "capsule_service" {
  description = "Name of the service this DB relates to. Used for the `capsule:service` tag and part of the instance naming."
  type        = string
}

variable "database_name" {
  description = "Name for an automatically created database on cluster creation. If `null`, `service_name` is used instead."
  type        = string
  default     = null
}

variable "engine_version" {
  description = "Aurora Postgres engine version. Must be in the format of `<major>.<minor>`. Default: \"13.9\"."
  type        = string
  default     = "13.9"
}

variable "engine_major_version" {
  description = "Aurora Postgres engine major version - used only for the Parameter Group family Default: `\"13\"`"
  type        = string
  default     = "13"
}

variable "user_name" {
  description = "Master DB username"
  type        = string
  default     = null
}

variable "password" {
  description = "Master DB password. At least 8 printable ASCII characters. Can't contain any of the following: / (slash), '(single quote), \"(double quote) and @ (at sign)."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_group" {
  description = "The existing subnet group name to use"
  type        = string
}

variable "instance_type" {
  description = "Instance type to use at master instance."
  type        = string
}

variable "min_capacity" {
  description = "Starting capacity of the server. Valid capacity values are (`2`, `4`, `8`, `16`, `32`, `64`, `192`, and `384`). Defaults to `2`"
  type        = number
  default     = 2
}

variable "max_capacity" {
  description = "The max capacity that the server can scale to. Valid capacity values are (`2`, `4`, `8`, `16`, `32`, `64`, `192`, and `384`)."
  type        = number
}

variable "seconds_until_auto_pause" {
  description = "The time, in seconds, before the DB cluster is paused. Valid values are 300 through 86400. Defaults to 300"
  type        = number
  default     = 300
}

variable "deletion_protection" {
  type        = bool
  default     = false
  description = "Whether to enable deletion protection for the RDS instance. Value is `true` when `capsule_env = production`"
}

variable "apply_immediately" {
  description = "Whether to apply Database modifications immediately"
  type        = bool
  default     = true
}
variable "auto_pause" {
  description = "Whether to allow pausing the cluster when there is no activity"
  type        = bool
  default     = true
}

variable "allowed_cidr_blocks" {
  type        = list(string)
  default     = []
  description = "CIDR blocks that are allowed to connect to the cluster"
}

variable "allowed_security_groups" {
  type        = list(string)
  default     = []
  description = "Security groups that are allowed to connect to the cluster"
}

variable "vpc_security_group_ids" {
  description = "List of VPC security groups to associate to the cluster in addition to the SG we create in this module"
  type        = list(string)
  default     = []
}

#-------------#
# vanta_tags  #
#-------------#

variable "vanta_owner" {
  description = "Vanta specific tag to identify resource owner"
  type        = string
  default     = "Global"
}

variable "vanta_nonprod" {
  description = "Vanta specific tag to indicate if ther resource is non-prod"
  type        = bool
  default     = true
}

variable "vanta_description" {
  description = "Vanta specific tag to specify the purpose of resource"
  type        = string
  default     = "RDS Serverless Service"
}

variable "vanta_user_data" {
  description = "Vanta specific tag to specify if the resource will contain user data"
  type        = bool
  default     = false

}

variable "vanta_user_data_stored" {
  description = "Vanta specific tag to specify the type of data the resource transacts/stores"
  type        = string
  default     = "None"
}

variable "vanta_contains_ephi" {
  description = "Vanta specific tag to specify if the resource contains electronic protected health information (ePHI)"
  type        = bool
  default     = false
}
