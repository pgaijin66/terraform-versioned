locals {
  private_route_table_ids = var.transit_gateway_id != "" ? module.vpc.private_route_table_ids : []
}

resource "aws_eip" "nat" {
  count = var.nat_count
  vpc   = true

  tags = {
    Name = "${var.name}-nat-ip-${count.index}"
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.59.0"

  name                     = var.name
  cidr                     = var.cidr
  azs                      = var.availability_zones
  private_subnets          = var.private_subnets
  public_subnets           = var.public_subnets
  database_subnets         = var.database_subnets
  single_nat_gateway       = true
  enable_nat_gateway       = true
  enable_vpn_gateway       = false
  enable_dns_support       = true
  enable_dns_hostnames     = true
  reuse_nat_ips            = true
  external_nat_ip_ids      = aws_eip.nat.*.id
  enable_dhcp_options      = true
  dhcp_options_domain_name = var.domain_name

  vpc_tags = {
    for cluster in var.clusters :
    "kubernetes.io/cluster/${cluster}" => "shared"
  }

  private_subnet_tags = merge({
    "kubernetes.io/role/internal-elb" = "true"
    },
    {
      for cluster in var.clusters :
      "kubernetes.io/cluster/${cluster}" => "shared"
  })

  public_subnet_tags = {
    for cluster in var.clusters :
    "kubernetes.io/cluster/${cluster}" => "shared"
  }

  tags = merge(var.tags, {
    "capsule:env"     = var.capsule_env,
    "capsule:team"    = var.capsule_team,
    "capsule:service" = "vpc"
  })
}


resource "aws_route" "rfc1918_route_10" {
  for_each               = toset(local.private_route_table_ids)
  route_table_id         = each.value
  destination_cidr_block = "10.0.0.0/8"
  transit_gateway_id     = var.transit_gateway_id
}
