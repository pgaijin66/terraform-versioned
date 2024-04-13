data "aws_caller_identity" "current" {}

data "aws_kms_key" "aws_rds" {
  key_id = "alias/aws/rds"
}

locals {
  identifier = var.legacy_identifier != null ? var.legacy_identifier : "${var.capsule_service}-${var.capsule_env}"
  parameters = var.parameters

  is_prod             = contains(["prod", "production"], var.capsule_env)
  vanta_tags_required = local.is_prod ? true : false
  insights_enabled    = local.is_prod ? true : var.performance_insights_enabled

  tags = {
    terraform             = "true"
    Name                  = local.identifier
    autoshutdown          = var.auto_shutdown != null ? var.auto_shutdown : (contains(["dev"], var.capsule_env) ? true : false)
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

resource "aws_db_parameter_group" "this" {
  name        = "${local.identifier}-parameter-group"
  description = "Parameter group for ${local.identifier}"
  family      = var.param_group_family

  dynamic "parameter" {
    for_each = local.parameters
    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = lookup(parameter.value, "apply_method", null)
    }
  }

  tags = merge(local.tags, {
    Name = "${local.identifier}-parameter-group"
  })
}

resource "aws_db_instance" "this" {
  identifier = local.identifier

  engine                = var.engine
  engine_version        = var.engine_version
  instance_class        = var.instance_class
  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_type          = var.storage_type
  iops                  = var.storage_type == "io1" ? var.iops : null
  storage_encrypted     = true

  username = var.username
  password = var.password
  port     = var.port
  db_name  = var.name

  iam_database_authentication_enabled = true

  snapshot_identifier = var.snapshot_identifier

  vpc_security_group_ids = var.vpc_security_group_ids
  db_subnet_group_name   = var.db_subnet_group_name
  parameter_group_name   = aws_db_parameter_group.this.name
  option_group_name      = var.option_group_name

  availability_zone = var.availability_zone
  multi_az          = local.is_prod ? true : var.multi_az

  publicly_accessible = false
  monitoring_interval = 60
  monitoring_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/rds-monitoring-role"

  allow_major_version_upgrade = var.allow_major_version_upgrade != null ? var.allow_major_version_upgrade : (local.is_prod ? false : true)
  auto_minor_version_upgrade  = var.auto_minor_version_upgrade
  maintenance_window          = var.maintenance_window

  # production can be specified by caller (default is 30 days), non-prod is fixed to 5 days
  backup_retention_period = local.is_prod ? var.backup_retention_period : 5
  backup_window           = var.backup_window

  apply_immediately        = var.apply_immediately
  deletion_protection      = local.is_prod ? true : var.deletion_protection
  delete_automated_backups = var.delete_automated_backups
  skip_final_snapshot      = var.skip_final_snapshot

  performance_insights_enabled          = local.insights_enabled
  performance_insights_kms_key_id       = local.insights_enabled ? data.aws_kms_key.aws_rds.arn : null
  performance_insights_retention_period = local.insights_enabled ? var.performance_insights_retention_period : null
  enabled_cloudwatch_logs_exports       = var.enabled_cloudwatch_logs_exports

  tags = local.tags
}
