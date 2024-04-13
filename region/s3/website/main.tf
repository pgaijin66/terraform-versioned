locals {
  #create a local to hold possible options - full redirect or no redirect. Can then use a dynamic block to pick one of these based on the value of var.website_redirect_all_requests_to
  website_options = {
    redirect_all = [
      {
        redirect_all_requests_to = var.website_redirect_all_requests_to
      }
    ]
    no_redirects = [
      {
        index_document = var.website_index_document
        error_document = var.website_error_document
        routing_rules  = var.website_routing_rules
      }
    ]
  }
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

  acl = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning {
    enabled = true
  }

  dynamic "website" {
    # if var.website_redirect_all_requests_to is empty, choose the no_redirects block from the options, else choose the redirect_all block
    for_each = local.website_options[var.website_redirect_all_requests_to == null ? "no_redirects" : "redirect_all"]

    #performing lookups in the block that was chosen allows setting a value to null if it's not set in that block. i.e. if redirect_all is chosen, it doesn't have values for index_document, etc.
    content {
      error_document           = lookup(website.value, "error_document", null)
      index_document           = lookup(website.value, "index_document", null)
      redirect_all_requests_to = lookup(website.value, "redirect_all_requests_to", null)
      routing_rules            = lookup(website.value, "routing_rules", null)
    }
  }

  dynamic "cors_rule" {
    # if var.cors_rule is empty, don't create cors rules. else use the var to set the necessary values
    for_each = var.cors_rule == null ? [] : var.cors_rule

    #performing lookups for optional values and setting them to null if they're not set.
    content {
      allowed_methods = cors_rule.value.allowed_methods
      allowed_origins = cors_rule.value.allowed_origins
      allowed_headers = lookup(cors_rule.value, "allowed_headers", null)
      expose_headers  = lookup(cors_rule.value, "expose_headers", null)
      max_age_seconds = lookup(cors_rule.value, "max_age_seconds", null)
    }
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
  depends_on = [
    aws_s3_bucket.this,
    aws_s3_bucket_public_access_block.this
  ]
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false

  # #--------------------------------------------------------------------------------
  # # To avoid OperationAborted: A conflicting conditional operation is currently in progress
  # #--------------------------------------------------------------------------------
  # depends_on = [
  #   aws_s3_bucket_policy.this
  # ]
}

resource "aws_s3_bucket_replication_configuration" "this" {
  count = length(var.replication_configuration_rule)

  bucket = aws_s3_bucket.this.id
  role   = var.replication_configuration_role

  dynamic "rule" {
    for_each = var.replication_configuration_rule

    content {
      status   = "Enabled"
      id       = lookup(rule.value, "id", null)
      priority = lookup(rule.value, "priority", null)

      dynamic "destination" {
        for_each = lookup(rule.value, "destination", null) != null ? [rule.value["destination"]] : []

        content {
          account = lookup(destination.value, "account", null)
          bucket  = lookup(destination.value, "bucket", null)
        }
      }
    }
  }
}
