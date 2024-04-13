locals {
  name = "${var.capsule_service}-${var.capsule_env}"

  vanta_tags_required = contains(["production", "prod"], var.capsule_env) ? true : false
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

module "rds_serverless" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "~> 5.2.0"

  name          = local.name
  database_name = var.database_name == null ? var.capsule_service : var.database_name
  engine        = "aurora-postgresql"
  engine_mode   = "serverless"

  allow_major_version_upgrade = false
  engine_version              = var.engine_version
  replica_scale_enabled       = false
  replica_count               = 0

  username = var.user_name == null ? var.capsule_service : var.user_name
  # Need to ensure we always use the set password and not a randomly set one
  create_random_password = false
  password               = var.password

  vpc_id                 = var.vpc_id
  db_subnet_group_name   = var.subnet_group
  create_security_group  = false
  vpc_security_group_ids = concat(var.vpc_security_group_ids, [aws_security_group.serverless.id])

  db_parameter_group_name         = aws_db_parameter_group.serverless.name
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.serverless.name

  instance_type       = var.instance_type
  deletion_protection = contains(["prod", "production"], var.capsule_env) ? true : var.deletion_protection
  apply_immediately   = var.apply_immediately
  skip_final_snapshot = true
  storage_encrypted   = true

  scaling_configuration = {
    auto_pause               = var.auto_pause
    min_capacity             = var.min_capacity
    max_capacity             = var.max_capacity
    seconds_until_auto_pause = var.seconds_until_auto_pause
    timeout_action           = "ForceApplyCapacityChange"
  }

  tags = local.tags
}

resource "aws_db_parameter_group" "serverless" {
  name        = local.name
  family      = "aurora-postgresql${var.engine_major_version}"
  description = "${local.name} parameter group"
}

resource "aws_rds_cluster_parameter_group" "serverless" {
  name        = local.name
  family      = "aurora-postgresql${var.engine_major_version}"
  description = "${local.name} cluster parameter group"
}

resource "aws_security_group" "serverless" {
  name   = "${local.name}-rds"
  vpc_id = var.vpc_id

  tags = merge(local.tags, {
    Name = local.name
  })
}

resource "aws_security_group_rule" "security_group_ingress" {
  for_each                 = toset(var.allowed_security_groups)
  type                     = "ingress"
  from_port                = module.rds_serverless.rds_cluster_port
  to_port                  = module.rds_serverless.rds_cluster_port
  protocol                 = "tcp"
  source_security_group_id = each.value
  security_group_id        = aws_security_group.serverless.id
}

resource "aws_security_group_rule" "cidr_ingress" {
  for_each          = toset(var.allowed_cidr_blocks)
  type              = "ingress"
  from_port         = module.rds_serverless.rds_cluster_port
  to_port           = module.rds_serverless.rds_cluster_port
  protocol          = "tcp"
  cidr_blocks       = [each.value]
  security_group_id = aws_security_group.serverless.id
}

resource "aws_security_group_rule" "egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.serverless.id
}
