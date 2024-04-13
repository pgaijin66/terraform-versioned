variable "service_account_name" {
  default     = ""
  type        = string
  description = "Name of service account"
}

variable "namespace" {
  default     = ""
  type        = string
  description = "Namespace to create service account"
}

variable "annotations" {
  default     = {}
  type        = map(string)
  description = "Annotations to be included within the serivce account metadata"
}

variable "create_role" {
  default     = false
  type        = bool
  description = "Whether to create a new role for the service account"
}

variable "create_cluster_role" {
  default     = false
  type        = bool
  description = "Whether to create a new cluster role for the service account"
}

variable "role_api_groups" {
  type        = list(string)
  default     = [""]
  description = "API groups to be applied to custom role"
}

variable "role_resources" {
  type        = list(string)
  default     = ["*"]
  description = "Resource types that a role is allowed manage."
}

variable "role_verbs" {
  type        = list(string)
  default     = ["*"]
  description = "Actions that role is allowed to perform"
}

variable "cluster_role_api_groups" {
  type        = list(string)
  default     = [""]
  description = "API groups to be applied to custom role"
}

variable "cluster_role_resources" {
  type        = list(string)
  default     = ["*"]
  description = "Resource types that a cluster role is allowed to manage."
}

variable "cluster_role_verbs" {
  type        = list(string)
  default     = ["*"]
  description = "Actions that cluster role is allowed to perform"
}
