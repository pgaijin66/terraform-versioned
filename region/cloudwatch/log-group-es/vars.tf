variable "name" {
  type        = string
  description = "The name of the log group"
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to apply to the log group"
  default     = {}
}
