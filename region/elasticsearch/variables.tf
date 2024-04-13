locals {
  name                        = var.legacy_name != null ? var.legacy_name : (var.name != null ? "${var.capsule_service}-${var.name}-${var.capsule_env}" : "${var.capsule_service}-${var.capsule_env}")
  log_group_name              = var.legacy_log_group_name != null ? var.legacy_log_group_name : (var.name != null ? "elasticsearch/${var.capsule_env}-${var.capsule_service}-${var.name}" : "elasticsearch/${var.capsule_env}-${var.capsule_service}")
  is_production               = var.capsule_env == "production"
  is_prod_aws                 = contains(["staging", "production"], var.capsule_env)
  eng_office_internal_subnets = ["10.100.0.0/20", "10.214.240.0/22"]
  vpc_name                    = local.is_prod_aws ? "vpc-internal" : "vpc-${var.capsule_env}"
  vpc_subnet_name_filter      = "${local.vpc_name}-private-*"

  # In production, use 3 master nodes by default. Otherwise, 0.
  # Override: var.master_node_instance_count
  default_master_node_instance_count_production = 3
  default_master_node_instance_count            = 0
  master_node_instance_count = (var.master_node_instance_count != null ?
    (var.master_node_instance_count)
    : (local.is_production ? local.default_master_node_instance_count_production : local.default_master_node_instance_count)
  )

  # In production, use 3 nodes by default. Otherwise, 2.
  # Override: var.node_instance_count
  default_node_instance_count_production = 3
  default_node_instance_count            = 2
  node_instance_count = (var.node_instance_count != null ?
    (var.node_instance_count)
    : (local.is_production ? local.default_node_instance_count_production : local.default_node_instance_count)
  )

  # We have a 2-AZ setup in production for increased reliability. Otherwise, use 1 subnet.
  num_subnets = (var.enable_zone_awareness || local.is_production) ? 2 : 1
}

######################
# REQUIRED VARIABLES #
######################
variable "elasticsearch_version" {
  type        = string
  description = "The ElasticSearch version to use"

  validation {
    condition     = contains(["7.10", "7.9", "7.8", "7.7", "7.4", "7.1"], var.elasticsearch_version)
    error_message = "The selected ElasticSearch version is invalid. Use one of: (7.10, 7.9, 7.8, 7.7, 7.4, 7.1)."
  }
}

variable "capsule_team" {
  type        = string
  description = "The name of the Capsule team that this resource will be associated with"
}

variable "capsule_service" {
  type        = string
  description = "The name of the Capsule service that this resource will be associated with"
}

variable "capsule_env" {
  type        = string
  description = "The Capsule environment that this resource will be deployed into (dev, staging, production)"
}

######################
# OPTIONAL VARIABLES #
######################
variable "name" {
  type        = string
  default     = null
  description = "The name to give the ElasticSearch domain that you want to create. By default, there is no name and it will be named {capsule_service}-{capsule_env}"
}

variable "legacy_name" {
  type        = string
  default     = null
  description = "Do not use this value, it is reserved for legacy resources and will be deprecated in the future."
}

variable "legacy_log_group_name" {
  type        = string
  default     = null
  description = "Do not use this value, it is reserved for legacy resources and will be deprecated in the future."
}

# Instance types: https://awscli.amazonaws.com/v2/documentation/api/latest/reference/es/describe-elasticsearch-instance-type-limits.html
variable "master_node_instance_type" {
  type        = string
  default     = "r5.large.elasticsearch"
  description = "The instance type to use for dedicated master nodes"
}

variable "master_node_instance_count" {
  type        = number
  default     = null
  description = "The number of dedicated master node instances to run on the cluster. Set to 0 to disable master nodes"

  validation {
    condition     = var.master_node_instance_count == null ? true : (var.master_node_instance_count > 1 || var.master_node_instance_count == 0)
    error_message = "For stability reasons, using 1 master node instance is not allowed. Recommended value is 3 nodes."
  }
}

# Instance types: https://awscli.amazonaws.com/v2/documentation/api/latest/reference/es/describe-elasticsearch-instance-type-limits.html
variable "node_instance_type" {
  type        = string
  default     = "r5.large.elasticsearch"
  description = "The instance type to use for scaling nodes in the cluster"
}

variable "node_instance_count" {
  type        = number
  default     = null
  description = "The number of instances to run on the cluster"

  validation {
    condition     = var.node_instance_count == null ? true : (var.node_instance_count > 0)
    error_message = "You can't have 0 nodes in a cluster. Silly!"
  }
}

# Volume size depends on instance type. Check for compatibility.
# https://docs.aws.amazon.com/opensearch-service/latest/developerguide/supported-instance-types.html
variable "ebs_volume_size" {
  type        = number
  default     = 100
  description = "EBS volumes for data storage in GB"
}

variable "ebs_volume_type" {
  type        = string
  default     = "gp2"
  description = "Storage type of EBS volumes"

  validation {
    condition     = contains(["standard", "gp2", "io1"], var.ebs_volume_type)
    error_message = "The selected ElasticSearch EBS volume type is invalid. Use one of: (standard, gp2, io1)."
  }
}

variable "ebs_iops" {
  type        = number
  default     = 0
  description = "The baseline input/output (I/O) performance of EBS volumes attached to data nodes. Applicable only for the Provisioned IOPS EBS volume type"

  validation {
    condition     = var.ebs_iops == 0 || (16000 >= var.ebs_iops && var.ebs_iops >= 1000)
    error_message = "The EBS IOPS must be between 1000 and 16000."
  }
}

variable "warm_count" {
  type        = number
  default     = 0
  description = "The warm node count. Must be between 2 and 150"
}

variable "warm_type" {
  type        = string
  default     = null
  description = "The warm node type. Must be ultrawarm1.medium.elasticsearch, ultrawarm1.large.elasticsearch, or ultrawarm1.xlarge.elasticsearch"
}

variable "iam_actions" {
  type        = list(string)
  default     = ["es:ESHttpGet", "es:ESHttpPut", "es:ESHttpPost"]
  description = "List of actions to allow for the IAM roles, _e.g._ `es:ESHttpGet`, `es:ESHttpPut`, `es:ESHttpPost`"
}

variable "iam_role_arns" {
  type        = list(string)
  default     = []
  description = "List of IAM role ARNs to permit access to the Elasticsearch domain. This module already creates an IAM role, but you can specify additional ones."
}

variable "cloudwatch_log_group_retention_in_days" {
  type        = number
  default     = 30
  description = "How many days to retain cluster logs in Cloudwatch."
}

variable "enable_zone_awareness" {
  type        = bool
  default     = false
  description = "Whether or not the domain is aware of other zones."
}

variable "access_policies" {
  type        = string
  default     = null
  description = "IAM policy document specifying the access policies for the domain"
}
