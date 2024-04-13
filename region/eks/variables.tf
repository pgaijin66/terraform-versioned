variable "capsule_team" {
  default     = "sre"
  description = "The name of the team that this Cluster will be associated with"
  type        = string
}

variable "capsule_service" {
  default     = "sre"
  description = "The name of the service (team) that this Cluster will be associated with"
  type        = string
}

variable "capsule_env" {
  description = "The environment that this Cluster will be deployed into (dev, staging, production)"
  type        = string
}

variable "cluster_enabled_log_types" {
  default = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]
  type        = list(string)
  description = "List of k8s logs to send to cloudwatch"
}

variable "cluster_endpoint_private_access" {
  default     = false
  type        = bool
  description = "Restricts access to the api server from inside the VPC only"
}

variable "cluster_endpoint_public_access" {
  default     = true
  type        = bool
  description = "Allows access to the api server from the internet"
}

variable "cluster_map_roles" {
  default = []
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))
  description = "List of roles to add to the aws-auth configmap"
}

variable "cluster_map_users" {
  default = []
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))
  description = "List of users to add to the aws-auth configmap"
}

variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster"
}

variable "cluster_subnets" {
  default     = []
  type        = list(string)
  description = "List of subnets to allocate to the nodes"
}

variable "cluster_version" {
  default     = "1.19"
  type        = string
  description = "Version k8s to use when creating the EKS cluster"
}

variable "fargate_profiles" {
  default     = {}
  type        = any
  description = "Map of fargate profiles to create"
}

variable "kubeconfig_aws_authenticator_additional_args" {
  default = []
  type    = list(string)
}

variable "manage_aws_auth" {
  default     = true
  type        = bool
  description = "Creates the aws-auth configmap in kube-system"
}

variable "node_groups" {
  default     = {}
  type        = any
  description = "List of node groups to create"
}

variable "node_groups_defaults" {
  default     = {}
  type        = any
  description = "List of defaults for node groups"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Map of tags to add the cluster"
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC where the EKS cluster will be created"
}

variable "worker_additional_security_group_ids" {
  default     = []
  type        = list(string)
  description = "additional security groups to add to worker nodes"
}

variable "worker_ami_name_filter" {
  default     = ""
  type        = string
  description = "Name filter used for selecting specific ami"
}

variable "worker_ami_name_filter_prefix" {
  default     = ""
  type        = string
  description = "prefix for filtering EKS amis"
}

variable "worker_groups" {
  default     = []
  type        = any
  description = "List of worker node groups to create"
}

variable "write_aws_auth_config" {
  default     = false
  type        = bool
  description = "Writes the aws-auth configmap in the terraform apply"
}

variable "write_kubeconfig" {
  default     = false
  type        = bool
  description = "Outputs the kubeconfig as part of the terraform apply"
}
