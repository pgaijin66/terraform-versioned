#########################################################
# locals
#########################################################
locals {
  config = yamldecode(file("${path.module}/env/dev/config.yml"))
}


#########################################################
# VPC
#########################################################
# tfsec:ignore:aws-ec2-require-vpc-flow-logs-for-all-vpcs
resource "aws_vpc" "vpc_use1" {
  cidr_block           = "10.10.1.12/23"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = false

  tags = {
    Env  = var.env,
    Name = "${upper(var.vpcs[0].name)}"
  }

}

# #########################################################
# # Internet Gateway
# #########################################################
# resource "aws_internet_gateway" "this" {
#   vpc_id = aws_vpc.vpc_use1.id
#   tags = {
#     Name = "${upper(var.vpcs[0].name)} IGW"
#   }
# }


# #########################################################
# # Subnets
# #########################################################
# resource "aws_subnet" "use1_1a_public" {
#   vpc_id     = aws_vpc.vpc_use1.id
#   cidr_block = var.vpcs[0].availability_zones[0].netblocks.cidr_subnet_public

#   tags = {
#     Subnet_type = "public",
#     Env         = var.env,
#     Name        = "${upper(var.vpcs[0].name)} Public"
#   }
# }

# resource "aws_subnet" "use1_1a_private" {
#   vpc_id     = aws_vpc.vpc_use1.id
#   cidr_block = var.vpcs[0].availability_zones[0].netblocks.cidr_subnet_private

#   tags = {
#     Subnet_type = "private",
#     Env         = var.env,
#     Name        = "${upper(var.vpcs[0].name)} Private"
#   }
# }


# #########################################################
# # Route tables
# #########################################################
# resource "aws_route_table" "use1_1a_public" {
#   vpc_id = aws_vpc.vpc_use1.id
#   tags = {
#     Name = "${upper(var.vpcs[0].name)} Public"
#   }
# }

# resource "aws_route_table" "use1_1a_private" {
#   vpc_id = aws_vpc.vpc_use1.id
#   tags = {
#     Name = "${upper(var.vpcs[0].name)} Private"
#   }
# }


# #########################################################
# # Routes
# #########################################################
# resource "aws_route" "public" {
#   route_table_id            = aws_route_table.use1_1a_public.id
#   destination_cidr_block    = "0.0.0.0/0"
#   gateway_id = aws_internet_gateway.this.id
#   depends_on                = [aws_route_table.use1_1a_public]
# }

# #########################################################
# # Route table associations
# #########################################################
# resource "aws_route_table_association" "use1_1a_public" {
#   subnet_id      = aws_subnet.use1_1a_public.id
#   route_table_id = aws_route_table.use1_1a_public.id
# }

# resource "aws_route_table_association" "use1_1a_private" {
#   subnet_id      = aws_subnet.use1_1a_private.id
#   route_table_id = aws_route_table.use1_1a_private.id
# }