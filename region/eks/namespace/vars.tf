# Storage Class
variable "custom_storage_class" {
  default     = "true"
  type        = string
  description = "Set to true to enable a custom storage class"
}

variable "storage_class_name" {
  default     = ""
  type        = string
  description = "Metadata name of custom storage class"
}

variable "storage_provisioner" {
  default     = "kubernetes.io/aws-ebs"
  type        = string
  description = "Storage provisioner of custom storage class. Defaults to aws-ebs"
}

variable "storage_class_type" {
  default     = "gp2"
  type        = string
  description = "If custom_storage_class is true, used to set the type of disk used for the storage class"
}

variable "storage_class_reclaim_policy" {
  default     = "Delete"
  type        = string
  description = "Whether to keep or delete ebs volume after deployment is deleted. Valid values are 'Retain' or 'Delete'"
}

variable "namespace_name" {
  default     = ""
  type        = string
  description = "Name of the namespace to be created"
}

variable "cluster_name" {
  default     = ""
  type        = string
  description = "Name of cluster where k8s configuration is to be applied"
}

variable "region" {
  default     = ""
  type        = string
  description = "AWS region"
}
