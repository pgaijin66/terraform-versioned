variable "name" {
  type        = string
  description = "The name of the IAM role"
  default     = null
}

variable "grafana_roles" {
  type        = list(string)
  description = "The list of roles that can assume the Grafana cloudwatch read role"
}

variable "capsule_env" {
  type        = string
  description = "The environment name"
}

variable "capsule_team" {
  type        = string
  description = "The team name"
}

variable "capsule_service" {
  type        = string
  description = "The service name"
}
