data "aws_caller_identity" "current" {}

locals {
  identifier = var.legacy_identifier != null ? var.legacy_identifier : "${var.read_replica_suffix}-${var.capsule_env}"
  parameters = var.parameters

  is_prod             = contains(["prod", "production"], var.capsule_env)
  vanta_tags_required = local.is_prod ? true : false

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
  # do not create a param group if we were given one already
  count = var.existing_param_group_name != "" ? 0 : 1

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

  # upstream module's name for this var sounded like a boolean; name changed here for clarity
  replicate_source_db = var.source_database_identifier

  # Note: the AWS provider 4.x has added a regression that drops support
  #       for setting the engine_version of read replicas. Because of this, we
  #       will be unable to upgrade the RR prior to the primary database.
  #       https://github.com/hashicorp/terraform-provider-aws/issues/24887
  #
  # engine_version    = var.engine_version
  instance_class    = var.instance_class
  storage_type      = var.storage_type
  iops              = var.storage_type == "io1" ? var.iops : null
  storage_encrypted = true
  allocated_storage = var.allocated_storage

  port                                = var.port
  iam_database_authentication_enabled = true

  snapshot_identifier = var.snapshot_identifier

  vpc_security_group_ids = var.vpc_security_group_ids
  parameter_group_name   = var.existing_param_group_name != "" ? var.existing_param_group_name : aws_db_parameter_group.this[0].name
  option_group_name      = var.option_group_name

  availability_zone = var.availability_zone
  multi_az          = var.multi_az

  publicly_accessible = false
  monitoring_interval = 60
  monitoring_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/rds-monitoring-role"

  allow_major_version_upgrade = var.allow_major_version_upgrade != null ? var.allow_major_version_upgrade : (local.is_prod ? false : true)
  auto_minor_version_upgrade  = var.auto_minor_version_upgrade
  maintenance_window          = var.maintenance_window
  apply_immediately           = var.apply_immediately

  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports

  deletion_protection = local.is_prod ? true : var.deletion_protection
  skip_final_snapshot = var.skip_final_snapshot

  tags = local.tags
}
