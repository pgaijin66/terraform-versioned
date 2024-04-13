locals {
  http_container_port              = "44135"
  tiller_container_port            = "44134"
  service_account_token_mount_path = "/var/run/secrets/kubernetes.io/serviceaccount"

  labels = {
    app  = "helm"
    name = var.tiller_name
  }
}

variable "tiller_name" {
  description = "Name of the objects associated with Tiller."
  default     = "tiller-deploy"
}

variable "tiller_namespace" {
  description = "Namespace to deploy Tiller."
  default     = "kube-system"
}

variable "tiller_version" {
  description = "Tiller version."
  default     = "v2.13.1"
}

variable "tiller_service_type" {
  description = "Tiller Service object type."
  default     = "ClusterIP"
}

variable "tiller_history_max" {
  description = "The maximum number of revisions saved per release. Use 0 for no limit."
  default     = "0"
}

variable "secret_name" {
  type    = string
  default = ""
}
