locals {
  name = var.legacy_name != null ? var.legacy_name : (var.name != null ? "${var.capsule_service}-${var.name}-${var.capsule_env}" : "${var.capsule_service}-${var.capsule_env}")

  attributes = concat(
    [
      {
        name = var.range_key
        type = var.range_key_type
      },
      {
        name = var.hash_key
        type = var.hash_key_type
      }
    ],
    var.attributes
  )

  # Remove the first map from the list if no `range_key` is provided
  from_index = var.range_key != null ? 0 : 1

  attributes_final = slice(local.attributes, local.from_index, length(local.attributes))

  vanta_tags_required = var.capsule_env == "production" ? true : false
  tags = {
    VantaOwner            = local.vanta_tags_required ? coalesce(var.vanta_owner, "VALUE REQUIRED IF PROD") : var.vanta_owner
    VantaNonProd          = local.vanta_tags_required ? false : true
    VantaDescription      = local.vanta_tags_required ? coalesce(var.vanta_description, "VALUE REQUIRED IF PROD") : var.vanta_description
    VantaContainsUserData = local.vanta_tags_required ? var.vanta_user_data : false
    VantaUserDataStored   = local.vanta_tags_required ? coalesce(var.vanta_user_data_stored, "VALUE REQUIRED IF PROD") : var.vanta_user_data_stored
    VantaContainsEPHI     = local.vanta_tags_required ? var.vanta_contains_ephi : false
  }
}

resource "aws_dynamodb_table" "this" {
  name           = local.name
  billing_mode   = var.billing_mode
  read_capacity  = var.billing_mode == "PAY_PER_REQUEST" ? null : var.read_capacity
  write_capacity = var.billing_mode == "PAY_PER_REQUEST" ? null : var.write_capacity
  hash_key       = var.hash_key
  range_key      = var.range_key

  server_side_encryption {
    enabled     = var.enable_encryption
    kms_key_arn = var.encryption_kms_key_arn
  }

  dynamic "attribute" {
    for_each = local.attributes_final
    content {
      name = attribute.value["name"]
      type = attribute.value["type"]
    }
  }

  lifecycle {
    ignore_changes = [
      read_capacity,
      write_capacity
    ]
  }

  point_in_time_recovery {
    enabled = true
  }

  dynamic "ttl" {
    for_each = var.ttl_enabled ? [1] : []
    content {
      attribute_name = var.ttl_attribute
      enabled        = var.ttl_enabled
    }
  }

  tags = merge(local.tags, {
    terraform         = "true"
    Name              = local.name
    "capsule:env"     = var.capsule_env
    "capsule:team"    = var.capsule_team
    "capsule:service" = var.capsule_service
  })

  dynamic "global_secondary_index" {
    for_each = var.global_secondary_indices
    content {
      name               = global_secondary_index.value["name"]
      hash_key           = global_secondary_index.value["hash_key"]
      range_key          = global_secondary_index.value["range_key"]
      read_capacity      = var.billing_mode == "PAY_PER_REQUEST" ? null : global_secondary_index.value["read_capacity"]
      write_capacity     = var.billing_mode == "PAY_PER_REQUEST" ? null : global_secondary_index.value["write_capacity"]
      projection_type    = global_secondary_index.value["projection_type"]
      non_key_attributes = global_secondary_index.value["non_key_attributes"]
    }
  }
}
