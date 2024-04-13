# Select the VPC we want to attach this ES cluster to
data "aws_vpc" "selected" {
  tags = {
    Name = local.vpc_name
  }
}

# Private subnets associated with our VPC
data "aws_subnet_ids" "vpc_private_subnets" {
  vpc_id = data.aws_vpc.selected.id
  filter {
    name   = "tag:Name"
    values = [local.vpc_subnet_name_filter] # Get per the "private" naming convention
  }
  filter {
    name   = "cidr-block"
    values = ["*/19"]
  }
}

# Security groups
data "aws_security_group" "vpc_only" {
  vpc_id = data.aws_vpc.selected.id
  filter {
    name   = "tag:Name"
    values = ["vpc-*-only"]
  }
}

data "aws_security_group" "office" {
  vpc_id = data.aws_vpc.selected.id
  filter {
    name   = "tag:Name"
    values = ["vpc-*-office"]
  }
}