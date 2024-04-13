variable "name" {
  description = "The name of your VPC"
  type        = string
}

variable "cidr" {
  description = "The base CIDR block of the VPC; all subnets must be contained within this CIDR range."
  type        = string
}

variable "availability_zones" {
  description = "A list of the VPC's availability zones"
  type        = list(string)
}

variable "private_subnets" {
  description = "A list of CIDR blocks that will form the private subnets"
  type        = list(string)
}

variable "public_subnets" {
  description = "A list of CIDR blocks that will form the public subnets"
  type        = list(string)
}

variable "database_subnets" {
  description = "A list of CIDR blocks that will form the database subnets"
  type        = list(string)
}

variable "domain_name" {
  description = "Specifies DNS name for DHCP options set"
  type        = string
}

variable "nat_count" {
  description = "The number of EIPs to assign to the NAT"
  type        = number
}

variable "clusters" {
  description = "A list of Kube clusters to assign to this VPC"
  type        = list(string)
}

variable "transit_gateway_id" {
  description = "A transit gateway ID to assign to the AWS Route"
  type        = string
  default     = ""
}

variable "capsule_env" {
  description = "The Capsule environment this VPC will belong to"
  type        = string
}

variable "capsule_team" {
  description = "The Capsule team that owns this VPC"
  type        = string
}
