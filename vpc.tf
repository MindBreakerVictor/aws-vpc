resource "aws_vpc" "vpc" {
  cidr_block = var.main_cidr_block

  instance_tenancy     = var.instance_tenancy
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  assign_generated_ipv6_cidr_block = var.ipv6_cidr_block

  tags = merge(var.tags, { Name = var.name })
}
