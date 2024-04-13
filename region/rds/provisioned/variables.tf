#----------#
# database #
#----------#

variable "engine" {
  type        = string
  description = "Database engine to use"
}

variable "engine_version" {
  type        = string
  description = "Database engine version to use"
}

variable "instance_class" {
  type        = string
  description = "RDS instance class to use"
}

variable "allocated_storage" {
  type        = string
  description = "Amount of allocated storage to provision for the RDS instance"
}

variable "max_allocated_storage" {
  type        = number
  default     = 0
  description = "Maximum amount of allocated storage to provision for the RDS instance"
}

variable "storage_type" {
  type        = string
  default     = "gp2"
  description = "Storage type to use for the RDS instance"

  validation {
    # our list is smaller than what is really supported
    condition     = contains(["gp2", "gp3", "io1"], var.storage_type)
    error_message = "The storage_type is invalid. Use one of: (gp2, gp3, io1)."
  }
}

variable "iops" {
  type        = number
  default     = 0
  description = "Amount of IOPS to provision for the RDS instance, used only when `storage_type == io1`"
}

variable "name" {
  type        = string
  default     = ""
  description = "Name of the RDS instance"
}

variable "username" {
  type        = string
  description = "Master username for the RDS instance"
}

variable "password" {
  description = "At least 8 printable ASCII characters. Can't contain any of the following: / (slash), '(single quote), \"(double quote) and @ (at sign)."
  type        = string
}

variable "port" {
  type        = string
  default     = "5432"
  description = "Port to use for the RDS instance"
}

variable "snapshot_identifier" {
  type        = string
  default     = ""
  description = "Snapshot identifier to use for the RDS instance"
}

variable "vpc_security_group_ids" {
  type        = list(string)
  description = "IDs of the VPC security groups to apply to the RDS instance"
}

variable "db_subnet_group_name" {
  type        = string
  default     = ""
  description = "Name of the DB subnet group to use for the RDS instance"
}

variable "option_group_name" {
  type        = string
  default     = ""
  description = "Name of the option group to use for the RDS instance"
}

variable "availability_zone" {
  type        = string
  default     = ""
  description = "Availability zone to use for the RDS instance"
}

variable "multi_az" {
  type        = bool
  default     = false
  description = "Whether to use a multi-AZ deployment for the RDS instance. Value is `true` if `capsule_env == production` else `false` (can be overriden)."
}

variable "allow_major_version_upgrade" {
  type        = bool
  default     = null # caller can specify, otherwise it gets automatically set
  description = "Whether to allow major version upgrades for the RDS instance. If not specified, value is `true` if `capsule_env != production` else `false`."
}

variable "auto_minor_version_upgrade" {
  type        = bool
  default     = true
  description = "Whether to apply minor version upgrades automatically for the RDS instance"
}

variable "apply_immediately" {
  type        = bool
  default     = true
  description = "Whether to apply the changes to the instance configuration and parameter group immediately"
}

variable "maintenance_window" {
  type        = string
  default     = "sun:06:00-sun:06:30"
  description = "Maintenance window to use for the RDS instance"
}

variable "backup_retention_period" {
  type        = number
  default     = 30
  description = "Number of days to retain automated backups. Default: 30 for production (can be overriden), 5 for non-production (fixed)"
}

variable "backup_window" {
  type        = string
  default     = "04:00-04:30"
  description = "Time window to use for automated backups"
}

variable "enabled_cloudwatch_logs_exports" {
  type        = list(string)
  default     = []
  description = "List of enabled cloudwatch logs exports"
}

variable "deletion_protection" {
  type        = bool
  default     = false
  description = "Whether to enable deletion protection for the RDS instance. Value is `true` when `capsule_env == production` else `false` (can be overriden)."
}

variable "delete_automated_backups" {
  type        = bool
  default     = false
  description = "Whether to delete automated backups after the RDS instance is deleted"
}

variable "skip_final_snapshot" {
  type        = bool
  default     = false
  description = "Whether to skip the final snapshot after the RDS instance is deleted"
}

variable "performance_insights_enabled" {
  type        = bool
  default     = false
  description = "Whether to enable Performance Insights. Value is `true` when `capsule_env == production` else `false` (can be overriden)."
}

variable "performance_insights_retention_period" {
  type        = number
  default     = 7
  description = "Amount of time in days to retain Performance Insights data (if enabled)"
}

variable "legacy_identifier" {
  type        = string
  default     = null
  description = "Legacy identifier for the RDS instance, can be used when db name does not conform to `servicename-environment` format"
}

#-------------#
# param group #
#-------------#
variable "param_group_family" {
  type        = string
  description = "Database parameter group family to use"
}

variable "parameters" {
  type        = list(map(string))
  default     = []
  description = "List of database parameter group parameters to use"
}

#--------#
#  tags  #
#--------#
variable "capsule_env" {
  type        = string
  description = "Environment that the RDS instance is in"
}

variable "capsule_team" {
  type        = string
  description = "Team that maintains the RDS instance"
}

variable "capsule_service" {
  type        = string
  description = "Service that uses the RDS instance"
}

variable "auto_shutdown" {
  type        = bool
  default     = null # caller can specify, otherwise it gets automatically set
  description = "Enables auto shutdown for the instance during off-hours, performed by the startRDS/stopRDS Lambdas. If not specified, value is `true` if `capsule_env == dev` else `false`."
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
  description = "Vanta specific tag to indicate if the resource is non-prod"
  type        = bool
  default     = true
}

variable "vanta_description" {
  description = "Vanta specific tag to specify the purpose of resource"
  type        = string
  default     = "RDS Service"
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
