variable "source_db_arn" {
  type        = string
  description = "The ARN of the source database instance."
}

variable "retention_period" {
  type        = number
  description = "Retention period for backups"
  default     = 14
}
