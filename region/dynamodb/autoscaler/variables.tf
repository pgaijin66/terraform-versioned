########
# TABLE VARS
########
variable "table_name" {
  type        = string
  description = "The NAME of the DynamoDB table to apply the autoscaling policy to"
}


########
# READS
########
variable "max_read_capacity" {
  type        = number
  description = "The maximum read capacity units when scaling"

  validation {
    condition     = var.max_read_capacity >= 1
    error_message = "Maximum read capacity must be greater than 0."
  }
}

variable "min_read_capacity" {
  type        = number
  description = "The minimum read capacity units when scaling"

  validation {
    condition     = var.min_read_capacity >= 1
    error_message = "Minimum read capacity must be greater 0."
  }
}

variable "read_target_utilization" {
  type        = number
  description = "The read capacity target utilization, expressed as a percentage. AWS will scale up/down to keep utilization close to this percentage"
}


########
# WRITES
########
variable "max_write_capacity" {
  type        = number
  description = "The maximum write capacity units when scaling"

  validation {
    condition     = var.max_write_capacity >= 1
    error_message = "Maximum write capacity must be greater than 0."
  }
}

variable "min_write_capacity" {
  type        = number
  description = "The minimum write capacity units when scaling"

  validation {
    condition     = var.min_write_capacity >= 1
    error_message = "Minimum write capacity must be greater 0."
  }
}

variable "write_target_utilization" {
  type        = number
  description = "The write capacity target utilization, expressed as a percentage. AWS will scale up/down to keep utilization close to this percentage"
}