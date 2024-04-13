locals {
  vanta_tags_required = contains(["production", "prod"], var.capsule_env) ? true : false

  tags = {
    terraform = "true"

    "capsule:env"     = var.capsule_env
    "capsule:team"    = var.capsule_team
    "capsule:service" = var.capsule_service

    VantaOwner            = local.vanta_tags_required ? coalesce(var.capsule_team, "VALUE REQUIRED ONLY FOR PROD") : var.capsule_team
    VantaNonProd          = local.vanta_tags_required ? false : true
    VantaDescription      = local.vanta_tags_required ? coalesce(var.vanta_description, "VALUE REQUIRED ONLY FOR PROD") : var.vanta_description
    VantaContainsUserData = local.vanta_tags_required ? var.vanta_user_data : false
    VantaUserDataStored   = local.vanta_tags_required ? coalesce(var.vanta_user_data_stored, "VALUE REQUIRED ONLY FOR PROD") : var.vanta_user_data_stored
    VantaContainsEPHI     = local.vanta_tags_required ? var.vanta_contains_ephi : false
  }
}

resource "aws_sns_topic" "this" {
  name                        = var.name
  kms_master_key_id           = var.kms_key_id
  fifo_topic                  = var.fifo_topic
  content_based_deduplication = var.content_based_deduplication

  tags = local.tags
}
