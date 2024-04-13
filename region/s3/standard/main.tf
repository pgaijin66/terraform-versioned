locals {
  # if the access var is set to private, close everything down, else open it up.
  acl                     = var.access == "private" ? "private" : null
  block_public_acls       = var.access == "private" ? true : false
  block_public_policy     = var.access == "private" ? true : false
  ignore_public_acls      = var.access == "private" ? true : false
  restrict_public_buckets = var.access == "private" ? true : false

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

resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name

  #if list of grants is greater than 0, set acl to null
  acl = try(length(var.grants), 0) == 0 ? local.acl : null

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  dynamic "grant" {
    for_each = try(length(var.grants), 0) == 0 ? [] : var.grants

    content {
      id          = lookup(grant.value, "id", null)
      type        = lookup(grant.value, "type", null)
      permissions = lookup(grant.value, "permissions", null)
      uri         = lookup(grant.value, "uri", null)
    }
  }

  dynamic "cors_rule" {
    # if var.cors_rule is empty, don't create cors rules. else use the var to set the necessary values
    for_each = try(length(var.cors_rule), 0) == 0 ? [] : var.cors_rule

    # performing lookups for optional values and setting them to null if they're not set
    content {
      allowed_methods = cors_rule.value.allowed_methods
      allowed_origins = cors_rule.value.allowed_origins
      allowed_headers = lookup(cors_rule.value, "allowed_headers", null)
      expose_headers  = lookup(cors_rule.value, "expose_headers", null)
      max_age_seconds = lookup(cors_rule.value, "max_age_seconds", null)
    }
  }

  dynamic "lifecycle_rule" {
    # if var.lifecycle_rule is empty don't create lifecycle rules, else use the var to set the necessary values
    for_each = try(length(var.lifecycle_rule), 0) == 0 ? [] : var.lifecycle_rule

    content {
      prefix  = lifecycle_rule.value.prefix
      enabled = lifecycle_rule.value.enabled
      expiration {
        days = lifecycle_rule.value.expiration_days
      }
      noncurrent_version_expiration {
        days = 1
      }
      id = lifecycle_rule.value.id
    }
  }

  versioning {
    enabled = var.versioning
  }

  tags = merge(local.tags, {
    terraform         = "true"
    Name              = var.bucket_name
    "capsule:env"     = var.capsule_env
    "capsule:team"    = var.capsule_team
    "capsule:service" = var.capsule_service
  })
}

resource "aws_s3_bucket_policy" "this" {
  count = var.bucket_policy != null ? 1 : 0

  bucket = aws_s3_bucket.this.id
  policy = var.bucket_policy
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = local.block_public_acls
  block_public_policy     = local.block_public_policy
  ignore_public_acls      = local.ignore_public_acls
  restrict_public_buckets = local.restrict_public_buckets

  #----------------------------------------------------------------------------------------
  # To avoid OperationAborted: A conflicting conditional operation is currently in progress
  #----------------------------------------------------------------------------------------
  depends_on = [
    aws_s3_bucket_policy.this
  ]
}
