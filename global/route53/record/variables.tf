variable "name" {
  type        = string
  description = "The name of the DNS record. (Required)"
}

variable "private" {
  type        = bool
  default     = false
  description = "Whether the record should be created in a private hosted zone."
}

variable "tld" {
  type        = string
  default     = null
  description = "The top-level domain."
}

variable "type" {
  type        = string
  default     = "A"
  description = "The Type of record to create. Must be \"A\" or \"CNAME\". (Required. Default = A)"

  validation {
    condition     = contains(["A", "CNAME"], upper(var.type))
    error_message = "The type value must be either A or CNAME."
  }
}

variable "ttl" {
  type        = number
  default     = 300
  description = "The TTL for the record. Default = 300."
}

variable "records" {
  type        = list(any)
  default     = null
  description = "List of destination record values. This attribute conflicts with alias."
}

variable "alias_name" {
  type        = string
  default     = null
  description = "Destination alias name. This attribute conflicts with records."
}

variable "alias_zone" {
  type        = string
  default     = null
  description = "Destination alias zone. This attribute conflicts with records."
}

variable "alias_evaluate" {
  type        = bool
  default     = true
  description = "Evaluate target alias health."
}

variable "ignore_record_value_changes" {
  type        = bool
  default     = false
  description = "After the DNS value is set for the record, ignore future changes."
}
