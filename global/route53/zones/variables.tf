variable "name" {
  type        = string
  description = "The name of the hosted zone."
}

variable "comment" {
  type        = string
  description = "A descriptor for the hosted zone."
  default     = null
}

variable "vpc" {
  type        = list(string)
  default     = []
  description = "The primary vpc to be associated with this zone if it's supposed to be a private one."
}

variable "force_destroy" {
  type        = string
  default     = "false"
  description = "Whether to destroy all records (possibly managed outside of Terraform) in the zone when destroying the zone."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Define any tags to be associated with this hosted zone."
}

variable "secondary_vpcs" {
  type        = list(string)
  default     = []
  description = "List of additional vpc IDs to be associated with this zone."
}
