locals {
  name = var.cache_name != null ? "${var.capsule_service}-${var.cache_name}-${var.capsule_env}" : "${var.capsule_service}-${var.capsule_env}"
  subnet_group_name = {
    # in infra-setup
    production = "vpc-internal-redis-subnet-group"
    staging    = "vpc-internal-redis-subnet-group"
    # in networking-infrastructure
    dev = "dev-redis-subnet-group"
    # for unit tests
    test = "dev-redis-subnet-group"
  }[var.capsule_env]

  # enable multi-AZ and automatic failover for production or if caller opts-in
  enable_failover = contains(["prod", "production"], var.capsule_env) ? true : var.enable_failover

  create_parameter_group = length(var.parameters) != 0

  vanta_tags_required = var.capsule_env == "production" ? true : false

  vanta_tags = {
    VantaOwner            = local.vanta_tags_required ? coalesce(var.vanta_owner, "VALUE REQUIRED IF PROD") : var.vanta_owner
    VantaNonProd          = local.vanta_tags_required ? false : true
    VantaDescription      = local.vanta_tags_required ? coalesce(var.vanta_description, "VALUE REQUIRED IF PROD") : var.vanta_description
    VantaContainsUserData = local.vanta_tags_required ? var.vanta_user_data : false
    VantaUserDataStored   = local.vanta_tags_required ? coalesce(var.vanta_user_data_stored, "VALUE REQUIRED IF PROD") : var.vanta_user_data_stored
    VantaContainsEPHI     = local.vanta_tags_required ? var.vanta_contains_ephi : false
  }
}

resource "aws_elasticache_replication_group" "cache_cluster_itself" {
  replication_group_id          = local.name
  replication_group_description = var.description
  engine                        = "redis"
  engine_version                = var.engine_version
  node_type                     = var.node_type
  security_group_ids            = var.security_group_ids
  subnet_group_name             = local.subnet_group_name

  parameter_group_name = local.create_parameter_group ? aws_elasticache_parameter_group.this[0].name : (var.family != null ? "default.redis${var.family}" : "default.redis${var.engine_version}")

  number_cache_clusters      = var.number_of_read_replicas + 1
  multi_az_enabled           = local.enable_failover # see logic above in locals
  automatic_failover_enabled = local.enable_failover # see logic above in locals

  # snapshots
  snapshot_retention_limit = 2
  snapshot_window          = "05:00-07:00" # arbitrarily early / off hours (UTC times)

  # take a snapshot when the cluster is going away (optional)
  final_snapshot_identifier = var.final_snapshot ? "${local.name}-final-snapshot" : null

  # no unexpected downtime
  apply_immediately          = true
  auto_minor_version_upgrade = false

  at_rest_encryption_enabled = true # could also set kms_key_id to use a managed key
  # does not address snapshotting at all, do we actually WANT snapshots?
  tags = merge(local.vanta_tags, {
    terraform         = "true"
    Name              = local.name
    "capsule:env"     = var.capsule_env
    "capsule:team"    = var.capsule_team
    "capsule:service" = var.capsule_service
  })
}

resource "aws_elasticache_parameter_group" "this" {
  count       = local.create_parameter_group ? 1 : 0
  name        = "${local.name}-parameter-group"
  description = "Parameter group for ${local.name}"
  family      = var.family != null ? "redis${var.family}" : "redis${var.engine_version}"

  dynamic "parameter" {
    for_each = var.parameters
    content {
      name  = parameter.value.name
      value = parameter.value.value
    }
  }

  tags = {
    terraform         = "true"
    Name              = "${local.name}-parameter-group"
    "capsule:env"     = var.capsule_env
    "capsule:team"    = var.capsule_team
    "capsule:service" = var.capsule_service
  }
}
