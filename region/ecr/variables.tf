variable "name" {
  description = "The name to give to the repository"
  type        = string
}

variable "expire_after_30_days" {
  description = "Whether to create a policy that will delete images older than 30 days. Useful for repos that will see frequent updates"
  type        = bool
  default     = false
}

variable "force_delete" {
  description = "Forcefully delete the ECR repository even if it contains images (dangerous)"
  type        = bool
  default     = false
}

variable "capsule_team" {
  description = "The name of the team that this repo will be associated with"
  type        = string
}

variable "capsule_service" {
  description = "The name of the service that this repo will be associated with"
  type        = string
}
