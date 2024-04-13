module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "17.24.0" # do not bump to 18+ as there are breaking changes

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  subnets         = var.cluster_subnets
  vpc_id          = var.vpc_id

  cluster_endpoint_private_access = var.cluster_endpoint_private_access
  cluster_endpoint_public_access  = var.cluster_endpoint_public_access

  cluster_enabled_log_types = var.cluster_enabled_log_types

  worker_additional_security_group_ids = var.worker_additional_security_group_ids
  worker_ami_name_filter               = var.worker_ami_name_filter

  worker_groups = var.worker_groups
  node_groups   = var.node_groups

  map_users = var.cluster_map_users
  map_roles = var.cluster_map_roles

  write_kubeconfig = var.write_kubeconfig
  manage_aws_auth  = var.manage_aws_auth

  kubeconfig_aws_authenticator_additional_args = var.kubeconfig_aws_authenticator_additional_args

  fargate_profiles = var.fargate_profiles

  tags = merge({
    terraform  = "true"
    kubernetes = "true"

    "capsule:env"     = var.capsule_env
    "capsule:service" = var.capsule_service
    "capsule:team"    = var.capsule_team
  }, var.tags)
}
