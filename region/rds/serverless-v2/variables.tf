variable "engine_version" {
  description = "Aurora Postgres engine version. Must be in the format of `<major>.<minor>`"
  type        = string
  default     = "14.5"
}

variable "engine_major_version" {
  description = "Aurora Postgres major version - used only for the Parameter Group family"
  type        = string
  default     = "14"
}

variable "database_name" {
  description = "Name for an automatically created database on creation. If not specified, `service_name` is used by default"
  type        = string
  default     = null
}

variable "username" {
  description = "Master DB username"
  type        = string
  default     = null
}

variable "password" {
  description = "Master DB password. At least 8 printable ASCII characters. Can't contain any of the following: / (slash), '(single quote), \"(double quote) and @ (at sign)."
  type        = string
}

variable "db_subnet_group_name" {
  description = "Name of the DB subnet group to use"
  type        = string
  default     = ""
}

variable "vpc_security_group_ids" {
  description = "IDs of the VPC security groups"
  type        = list(string)
  default     = []
}

variable "backup_retention_period" {
  description = "Number of days to retain automated backups. Default: 30 for production (can be overriden), 5 for non-production (fixed)"
  type        = number
  default     = 30
}

variable "backup_window" {
  description = "Time window to use for automated backups"
  type        = string
  default     = "04:00-04:30"
}

variable "maintenance_window" {
  description = "Maintenance window to apply updates"
  type        = string
  default     = "sun:06:00-sun:06:30"
}

variable "instance_class" {
  description = "Instance class to use for the provisioned instances"
  type        = string
  default     = "db.serverless" # special adjustable one for serverless-v2
}

variable "min_capacity" {
  description = "Starting capacity of the server. Valid capacity values are between `0.5` and `128` in increments of `0.5`"
  type        = number
  default     = 0.5
}

variable "max_capacity" {
  description = "The max capacity of the server. Valid capacity values are between `0.5` and `128` in increments of `0.5`"
  type        = number
}

variable "parameters" {
  description = "List of database parameter group parameters to use"
  type        = list(map(string))
  default     = []
}

variable "allow_major_version_upgrade" {
  description = "Whether to allow automatic major version upgrades"
  type        = bool
  default     = false
}

variable "auto_minor_version_upgrade" {
  description = "Whether to apply minor version upgrades automatically"
  type        = bool
  default     = true
}

variable "performance_insights_enabled" {
  description = "Whether to enable Performance Insights. Defaults to `true` when `capsule_env == production` `false` otherwise"
  type        = bool
  default     = false
}

variable "performance_insights_retention_period" {
  description = "Amount of time in days to retain Performance Insights data (if enabled)"
  type        = number
  default     = 7
}

variable "deletion_protection" {
  description = "Whether to enable deletion protection. Defaults to `true` when `capsule_env == production` `false` otherwise"
  type        = bool
  default     = false
}

variable "apply_immediately" {
  description = "Whether to apply Database modifications immediately"
  type        = bool
  default     = true
}

variable "legacy_name" {
  type        = string
  default     = null
  description = "Legacy name for the Serverless cluster, can be used when name does not conform to `service-environment-provisioned` format"
}

variable "legacy_identifier" {
  type        = string
  default     = null
  description = "Legacy identifier for the Serverless instance, can be used when name does not conform to `service-environment-provisioned-1` format"
}


#--------#
#  tags  #
#--------#
variable "capsule_env" {
  description = "Environment that the infra is in"
  type        = string
}

variable "capsule_team" {
  description = "Team that maintains the infra"
  type        = string
}

variable "capsule_service" {
  description = "Service that uses the infra"
  type        = string
}

variable "auto_shutdown" {
  description = "Optional tag that enables auto shutdown for the instance/cluster during off-hours, performed by the startRDS/stopRDS Lambdas"
  type        = bool
  default     = false
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
  description = "Vanta specific tag to indicate if the resource is non-prod"
  type        = bool
  default     = true
}

variable "vanta_description" {
  description = "Vanta specific tag to specify the purpose of resource"
  type        = string
  default     = "RDS ServerlessV2 Service"
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
