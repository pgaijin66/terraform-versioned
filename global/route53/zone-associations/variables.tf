variable "zoneId" {
  type        = string
  description = "The zone ID to associate with the vpc."
}

variable "vpcId" {
  type        = string
  description = "The vpc ID to assciate with the zone."
}

variable "region" {
  type        = string
  default     = ""
  description = "The region of the vpc."
}
