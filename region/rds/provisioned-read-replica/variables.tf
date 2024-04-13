#----------#
# database #
#----------#

variable "source_database_identifier" {
  type        = string
  description = "Identifier of the primary RDS instance that this Read Replica is going to follow"
}

variable "read_replica_suffix" {
  type    = string
  default = "read-replica"
}

variable "legacy_identifier" {
  type        = string
  default     = null
  description = "Legacy identifier for the RDS Read Replica, should only be used when migrating an existing Read Replica over"
}

# Note: the AWS provider 4.x has added a regression that drops support
#       for setting the engine_version of read replicas. Because of this, we
#       will be unable to upgrade the RR  prior to the primary database.
#       https://github.com/hashicorp/terraform-provider-aws/issues/24887
#
# variable "engine_version" {
#   type        = string
#   description = "Database engine version to use for the read replica. If not supplied it will default to the engine version of the primary instance."
#  default     = null
# }

variable "instance_class" {
  type        = string
  description = "RDS instance class to use"
}

variable "storage_type" {
  type        = string
  default     = "gp2"
  description = "Storage type to use for the RDS Read Replica"

  validation {
    # our list is smaller than what is really supported
    condition     = contains(["gp2", "gp3", "io1"], var.storage_type)
    error_message = "The storage_type is invalid. Use one of: (gp2, gp3, io1)."
  }
}

variable "iops" {
  type        = number
  default     = 0
  description = "Amount of IOPS to provision for the RDS Read Replica, used only when `storage_type == io1`"
}

variable "allocated_storage" {
  type        = number
  default     = null
  description = "The amount of storage, in gibibytes (GiB), to allocate for the RDS Read Replica. If source_database_identifier is set, the value is ignored during the creation of the Read Replica."
}

variable "port" {
  type        = string
  default     = "5432"
  description = "Port to use for the RDS Read Replica"
}

variable "snapshot_identifier" {
  type        = string
  default     = ""
  description = "Snapshot identifier to use for the RDS Read Replica"
}

variable "vpc_security_group_ids" {
  type        = list(string)
  description = "IDs of the VPC security groups to apply to the RDS Read Replica"
}

variable "option_group_name" {
  type        = string
  default     = ""
  description = "Name of the option group to use for the RDS Read Replica"
}

variable "availability_zone" {
  type        = string
  default     = ""
  description = "Availability zone to use for the RDS Read Replica"
}

variable "multi_az" {
  type        = bool
  default     = false
  description = "Whether to use a multi-AZ deployment for the RDS Read Replica. Default: `true` if `capsule_env == production` else `false` (can be overriden)."
}

variable "allow_major_version_upgrade" {
  type        = bool
  default     = null # caller can specify, otherwise it gets automatically set
  description = "Whether to allow major version upgrades for the RDS Read Replica. If not specified, value is `true` if `capsule_env != production` else `false`."
}

variable "auto_minor_version_upgrade" {
  type        = bool
  default     = true
  description = "Whether to apply minor version upgrades automatically for the RDS Read Replica"
}

variable "apply_immediately" {
  type        = bool
  default     = true
  description = "Changes are ignored until the maintainence window if apply_immediately is set to `false`"
}

variable "maintenance_window" {
  type        = string
  default     = "sun:06:00-sun:06:30"
  description = "Maintenance window to use for the RDS Read Replica"
}

variable "enabled_cloudwatch_logs_exports" {
  type        = list(string)
  default     = []
  description = "List of enabled cloudwatch logs exports"
}

variable "deletion_protection" {
  type        = bool
  default     = false
  description = "Whether to enable deletion protection for the RDS Read Replica. Value is `true` when `capsule_env == production` else `false` (can be overriden)."
}

variable "skip_final_snapshot" {
  type        = bool
  default     = false
  description = "Whether to skip the final snapshot after the RDS Read Replica is deleted"
}

#-------------#
# param group #
#-------------#
variable "existing_param_group_name" {
  type    = string
  default = ""
}

variable "param_group_family" {
  type    = string
  default = ""
}

variable "parameters" {
  type    = list(map(string))
  default = []
}

#--------#
#  tags  #
#--------#
variable "capsule_env" {
  type        = string
  description = "Environment that the RDS Read Replica is in"
}

variable "capsule_team" {
  type        = string
  description = "Team that maintains the RDS Read Replica"
}

variable "capsule_service" {
  type        = string
  description = "Service that uses the RDS Read Replica"
}

variable "auto_shutdown" {
  type        = bool
  default     = null # caller can specify, otherwise it gets automatically set
  description = "Tag that enables auto shutdown for the Read Replica during off-hours, performed by the startRDS/stopRDS Lambdas. If not specified, Defaults to true for dev, false otherwise."
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
  default     = "RDS RR Service"
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
