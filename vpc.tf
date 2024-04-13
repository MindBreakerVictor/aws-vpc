#tfsec:ignore:aws-ec2-require-vpc-flow-logs-for-all-vpcs
resource "aws_vpc" "vpc" {
  cidr_block = var.main_cidr_block

  instance_tenancy     = var.instance_tenancy
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  assign_generated_ipv6_cidr_block = var.ipv6_cidr_block

  tags = merge(var.tags, { Name = var.name })
}

# Delete rules from VPC's default Network ACL & Security Group and delete routes from default Route Table
resource "aws_default_network_acl" "acl" {
  default_network_acl_id = aws_vpc.vpc.default_network_acl_id
}

resource "aws_default_security_group" "sg" {
  vpc_id = local.vpc_id
}

resource "aws_default_route_table" "rtb" {
  default_route_table_id = aws_vpc.vpc.default_route_table_id
}
