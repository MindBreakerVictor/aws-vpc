module "vpc" {
  count = local.nv_vpc ? 1 : 0

  source = "../"

  name                     = "modtest"
  main_cidr_block          = "10.0.0.0/24"
  availability_zones_count = 4

  subnetting_algorithm = var.subnetting_algorithm
  private_subnets_only = var.private_subnets_only

  tags = local.common_tags

  providers = {
    aws = aws.nvirginia
  }
}

module "vpc_six_azs" {
  count = local.nv_six_azs_vpc ? 1 : 0

  source = "../"

  name                     = "modtest_six_azs"
  main_cidr_block          = "10.0.1.0/24"
  availability_zones_count = 6

  subnetting_algorithm = var.subnetting_algorithm
  private_subnets_only = var.private_subnets_only

  tags = local.common_tags

  providers = {
    aws = aws.nvirginia
  }
}

module "vpc_frankfurt" {
  source = "../"

  name                     = "modtest"
  main_cidr_block          = "10.0.2.0/24"
  availability_zones_count = 6

  subnetting_algorithm = var.subnetting_algorithm
  private_subnets_only = var.private_subnets_only
  nat_gateway_setup    = var.nat_gateway_setup
  flow_logs_config     = var.flow_logs_config

  tags = local.common_tags

  providers = {
    aws = aws.frankfurt
  }
}

# Locals
locals {
  nv_vpc         = false
  nv_six_azs_vpc = false

  common_tags = {
    Role = "Terraform Module aws-vpc Test"
    User = "victor611@yahoo.com"
  }
}
