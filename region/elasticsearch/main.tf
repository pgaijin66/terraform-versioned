#####
# Creates an ElasticSearch domain within a configured VPC - the main output of this module.
#####
resource "aws_cloudwatch_log_group" "log_group" {
  name              = local.log_group_name
  retention_in_days = var.cloudwatch_log_group_retention_in_days
  tags = {
    Name              = local.log_group_name,
    terraform         = "true",
    "capsule:team"    = var.capsule_team,
    "capsule:env"     = var.capsule_env,
    "capsule:service" = var.capsule_service
  }
}

resource "aws_elasticsearch_domain" "this" {
  domain_name           = local.name
  elasticsearch_version = var.elasticsearch_version

  cluster_config {
    # Master nodes
    dedicated_master_enabled = local.master_node_instance_count > 0 ? true : false
    dedicated_master_type    = var.master_node_instance_type
    dedicated_master_count   = local.master_node_instance_count

    # Non-master instance nodes
    instance_type  = var.node_instance_type
    instance_count = local.node_instance_count

    # Warm nodes
    warm_enabled = var.warm_count > 0 ? true : false
    warm_count   = var.warm_count > 0 ? var.warm_count : null
    warm_type    = var.warm_count > 0 ? var.warm_type : null

    # Enable multi-AZ deploy for increased reliability in production
    zone_awareness_enabled = local.is_production || var.enable_zone_awareness
    dynamic "zone_awareness_config" {
      for_each = (!var.enable_zone_awareness) ? [] : (local.is_production ? tolist([true]) : [])
      content {
        availability_zone_count = local.num_subnets
      }
    }
  }

  # We only allow ES clusters to live in private subnets in our VPC
  vpc_options {
    subnet_ids = slice(tolist(data.aws_subnet_ids.vpc_private_subnets.ids), 0, local.num_subnets)

    # Retrieved in security_group.tf
    security_group_ids = [
      data.aws_security_group.vpc_only.id,
      data.aws_security_group.office.id,
    ]
  }

  # EBS requirements may change based on instance type
  ebs_options {
    ebs_enabled = var.ebs_volume_size > 0 ? true : false
    volume_size = var.ebs_volume_size
    volume_type = var.ebs_volume_type
    iops        = var.ebs_iops
  }

  # Enforce data encryption by default
  encrypt_at_rest {
    enabled = true
  }

  # And in-transit across nodes
  node_to_node_encryption {
    enabled = true
  }

  access_policies = var.access_policies

  # Enable different logs and point to the same CW log group
  dynamic "log_publishing_options" {
    for_each = ["INDEX_SLOW_LOGS", "SEARCH_SLOW_LOGS", "ES_APPLICATION_LOGS"]
    content {
      enabled                  = true
      log_type                 = log_publishing_options.value
      cloudwatch_log_group_arn = aws_cloudwatch_log_group.log_group.arn
    }
  }

  tags = {
    terraform         = "true"
    Name              = local.name
    "capsule:env"     = var.capsule_env
    "capsule:team"    = var.capsule_team
    "capsule:service" = var.capsule_service
  }

  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true"
  }
}
