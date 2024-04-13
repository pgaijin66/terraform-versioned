data "aws_kms_key" "aws_rds" {
  key_id = "alias/aws/rds"
}

locals {
  name       = var.legacy_name != null ? var.legacy_name : "${var.capsule_service}-${var.capsule_env}-provisioned"
  identifier = var.legacy_identifier != null ? var.legacy_identifier : "${var.capsule_service}-${var.capsule_env}-provisioned"

  parameters = var.parameters

  is_prod             = contains(["prod", "production"], var.capsule_env)
  vanta_tags_required = local.is_prod ? true : false
  insights_enabled    = local.is_prod ? true : var.performance_insights_enabled

  tags = {
    Name                  = local.name
    terraform             = "true"
    "capsule:env"         = var.capsule_env
    "capsule:team"        = var.capsule_team
    "capsule:service"     = var.capsule_service
    VantaOwner            = local.vanta_tags_required ? coalesce(var.vanta_owner, "VALUE REQUIRED IF PROD") : var.vanta_owner
    VantaNonProd          = local.vanta_tags_required ? false : true
    VantaDescription      = local.vanta_tags_required ? coalesce(var.vanta_description, "VALUE REQUIRED IF PROD") : var.vanta_description
    VantaContainsUserData = local.vanta_tags_required ? var.vanta_user_data : false
    VantaUserDataStored   = local.vanta_tags_required ? coalesce(var.vanta_user_data_stored, "VALUE REQUIRED IF PROD") : var.vanta_user_data_stored
    VantaContainsEPHI     = local.vanta_tags_required ? var.vanta_contains_ephi : false
  }
}

resource "aws_rds_cluster" "this" {
  cluster_identifier = local.name
  engine             = "aurora-postgresql"
  engine_mode        = "provisioned"
  engine_version     = var.engine_version
  database_name      = var.database_name == null ? var.capsule_service : var.database_name
  master_username    = var.username == null ? var.capsule_service : var.username
  master_password    = var.password

  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.this.name
  db_subnet_group_name            = var.db_subnet_group_name
  vpc_security_group_ids          = var.vpc_security_group_ids

  # production can be specified by caller (default is 30 days), non-prod is fixed to 5 days
  backup_retention_period = contains(["prod", "production"], var.capsule_env) ? var.backup_retention_period : 5
  preferred_backup_window = var.backup_window

  skip_final_snapshot         = var.capsule_env == "production" ? false : true
  storage_encrypted           = true
  apply_immediately           = var.apply_immediately
  deletion_protection         = var.capsule_env == "production" ? true : var.deletion_protection
  copy_tags_to_snapshot       = true
  allow_major_version_upgrade = var.allow_major_version_upgrade

  serverlessv2_scaling_configuration {
    max_capacity = var.max_capacity
    min_capacity = var.min_capacity
  }

  tags = local.tags
}

resource "aws_rds_cluster_parameter_group" "this" {
  name        = local.name
  family      = "aurora-postgresql${var.engine_major_version}"
  description = "${local.name} cluster parameter group"

  dynamic "parameter" {
    for_each = local.parameters
    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = lookup(parameter.value, "apply_method", null)
    }
  }

  tags = local.tags
}

resource "aws_rds_cluster_instance" "this" {
  cluster_identifier = aws_rds_cluster.this.id
  identifier         = "${local.identifier}-1"
  instance_class     = var.instance_class

  engine         = aws_rds_cluster.this.engine
  engine_version = aws_rds_cluster.this.engine_version

  apply_immediately            = var.apply_immediately
  auto_minor_version_upgrade   = var.auto_minor_version_upgrade
  preferred_maintenance_window = var.maintenance_window

  db_subnet_group_name    = aws_rds_cluster.this.db_subnet_group_name
  db_parameter_group_name = aws_db_parameter_group.this.name

  performance_insights_enabled          = local.insights_enabled
  performance_insights_kms_key_id       = local.insights_enabled ? data.aws_kms_key.aws_rds.arn : null
  performance_insights_retention_period = local.insights_enabled ? var.performance_insights_retention_period : null

  promotion_tier = 0 # lower has higher priority

  tags = local.tags
}

resource "aws_db_parameter_group" "this" {
  name        = local.name
  family      = "aurora-postgresql${var.engine_major_version}"
  description = "${local.name} parameter group"

  dynamic "parameter" {
    for_each = local.parameters
    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = lookup(parameter.value, "apply_method", null)
    }
  }

  tags = local.tags
}
