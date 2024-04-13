variable "cache_name" {
  type        = string
  description = "Unique identifier for the cache. Must contain only alphanumeric characters and hyphens. Only necessary if you need more than one cache per service-env pair, otherwise omit."
  default     = null
}

variable "engine_version" {
  type        = string
  description = "The engine version for the cache. Must be in the format of `<major>.x`. Default: `6.x`."
  default     = "6.x"
}

variable "family" {
  type        = string
  description = "The family for the parameter group. Optional, since >6.x the format of the cache engine_version and param_group family is different."
  default     = null
}

variable "node_type" {
  type        = string
  description = "Machine type for your cache nodes. See https://aws.amazon.com/elasticache/pricing/ for details."
}

variable "number_of_read_replicas" {
  type        = number
  description = "Number of read replicas to add to your cluster. Max of 5. If you set this to 0, you will get a cluster with one node."
}

variable "description" {
  type        = string
  description = "Short form description for this cluster. What is it going to be used for? Helpful for SRE to know."
}

variable "security_group_ids" {
  description = "SG IDs to add to the new Redis cluster."
  type        = list(string)
}

variable "final_snapshot" {
  description = "Take a final snapshot before deleting the instance"
  type        = bool
  default     = true
}

variable "enable_failover" {
  type        = bool
  default     = false
  description = "Whether to use a multi-AZ deployment for the Cluster. Default: `true` if `capsule_env == production` else `false` (can be overriden)."
}

#--------#
# params #
#--------#

variable "parameters" {
  type        = list(map(string))
  default     = []
  description = "List of parameters to set. See https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/ParameterGroups.Redis.html for more information."
}

#--------#
#  tags  #
#--------#
variable "capsule_env" {
  type        = string
  description = "Environment this cache is in. e.g. dev, test, prod"
}

variable "capsule_team" {
  type        = string
  description = "Team that maintains this cache. e.g. sre"
}

variable "capsule_service" {
  type        = string
  description = "Service this cache is used for"
}

#--------------#
#  vanta_tags  #
#--------------#

variable "vanta_owner" {
  description = "Vanta specific tag to identify resource owner"
  type        = string
  default     = "Global"
}

variable "vanta_nonprod" {
  description = "Vanta specific tag to if resource is non-prod"
  type        = bool
  default     = false
}

variable "vanta_description" {
  description = "Vanta specific tag to specify the type of user data (if any) the resource transacts/stores"
  type        = string
  default     = "Redis Service"
}
variable "vanta_user_data" {
  description = "Vanta specific tag to specify if the resource will contain user data"
  type        = bool
  default     = false
}

variable "vanta_user_data_stored" {
  description = "Vanta specific tag to specify the type of data the resource transacts/stores"
  type        = string
  default     = "Stored Account Information"
}

variable "vanta_contains_ephi" {
  description = "Vanta specific tag to specify if the resource contains electronic protected health information (ePHI)"
  type        = bool
  default     = false
}
