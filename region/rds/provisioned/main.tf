# data "aws_caller_identity" "current" {}

# data "aws_kms_key" "aws_rds" {
#   key_id = "alias/aws/rds"
# }

# locals {
#   identifier = var.legacy_identifier != null ? var.legacy_identifier : "${var.capsule_service}-${var.capsule_env}"
#   parameters = var.parameters

#   is_prod             = contains(["prod", "production"], var.capsule_env)
#   vanta_tags_required = local.is_prod ? true : false
#   insights_enabled    = local.is_prod ? true : var.performance_insights_enabled

#   tags = {
#     terraform             = "true"
#     Name                  = local.identifier
#     autoshutdown          = var.auto_shutdown != null ? var.auto_shutdown : (contains(["dev"], var.capsule_env) ? true : false)
#     "capsule:env"         = var.capsule_env
#     "capsule:team"        = var.capsule_team
#     "capsule:service"     = var.capsule_service
#     VantaOwner            = local.vanta_tags_required ? coalesce(var.vanta_owner, "VALUE REQUIRED IF PROD") : var.vanta_owner
#     VantaNonProd          = local.vanta_tags_required ? false : true
#     VantaDescription      = local.vanta_tags_required ? coalesce(var.vanta_description, "VALUE REQUIRED IF PROD") : var.vanta_description
#     VantaContainsUserData = local.vanta_tags_required ? var.vanta_user_data : false
#     VantaUserDataStored   = local.vanta_tags_required ? coalesce(var.vanta_user_data_stored, "VALUE REQUIRED IF PROD") : var.vanta_user_data_stored
#     VantaContainsEPHI     = local.vanta_tags_required ? var.vanta_contains_ephi : false
#   }
# }

# resource "aws_db_parameter_group" "this" {
#   name        = "${local.identifier}-parameter-group"
#   description = "Parameter group for ${local.identifier}"
#   family      = var.param_group_family

#   dynamic "parameter" {
#     for_each = local.parameters
#     content {
#       name         = parameter.value.name
#       value        = parameter.value.value
#       apply_method = lookup(parameter.value, "apply_method", null)
#     }
#   }

#   tags = merge(local.tags, {
#     Name = "${local.identifier}-parameter-group"
#   })
# }
resource "aws_db_instance" "this" {
  allocated_storage    = 10
  db_name              = "mydb"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  username             = "foo"
  password             = "foobarbaz"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
}
}
