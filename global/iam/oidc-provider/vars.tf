variable "url" {
  type        = string
  description = "URL of the OIDC provider"
}

variable "audiences" {
  type        = list(string)
  description = "Audience(s) for the oauth requests"
  default     = ["sts.amazonaws.com"]
}

variable "thumbprints" {
  type        = list(string)
  description = "Server certificate thumbprints"
  default     = []
}
