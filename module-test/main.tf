module "vpc" {
  source = "../"

  name                     = "modtest"
  main_cidr_block          = "10.0.0.0/24"
  availability_zones_count = 4

  subnetting_algorithm = var.subnetting_algorithm
  only_private_subnets = var.only_private_subnets

  tags = local.common_tags

  providers = {
    aws = aws.nvirginia
  }
}

module "vpc_six_azs" {
  source = "../"

  name                     = "modtest_six_azs"
  main_cidr_block          = "10.0.1.0/24"
  availability_zones_count = 6

  subnetting_algorithm = var.subnetting_algorithm
  only_private_subnets = var.only_private_subnets

  tags = local.common_tags

  providers = {
    aws = aws.nvirginia
  }
}

module "vpc_ireland" {
  source = "../"

  name                     = "modtest"
  main_cidr_block          = "10.0.2.0/24"
  availability_zones_count = 6

  subnetting_algorithm = var.subnetting_algorithm
  only_private_subnets = var.only_private_subnets

  tags = local.common_tags

  providers = {
    aws = aws.ireland
   }
}

# Locals
locals {
  common_tags = {
    Role = "Terraform Module aws-vpc Test"
    User = "victor611@yahoo.com"
  }
}

# Outputs
# output "nv_azs_count" {
#   value = module.vpc.azs_count
# }

output "nv_private_subnet_addresses" {
  value = module.vpc.private_subnet_addresses
}

output "nv_public_subnet_addresses" {
  value = module.vpc.public_subnet_addresses
}

output "nv_unused_subnet_addresses" {
  value = module.vpc.unused_subnet_addresses
}

# output "six_azs_azs_count" {
#   value = module.vpc_six_azs.azs_count
# }

output "six_azs_private_subnet_addresses" {
  value = module.vpc_six_azs.private_subnet_addresses
}

output "six_azs_public_subnet_addresses" {
  value = module.vpc_six_azs.public_subnet_addresses
}

output "six_azs_unused_subnet_addresses" {
  value = module.vpc_six_azs.unused_subnet_addresses
}

# output "ireland_azs_count" {
#   value = module.vpc_ireland.azs_count
# }

output "ireland_private_subnet_addresses" {
  value = module.vpc_ireland.private_subnet_addresses
}

output "ireland_public_subnet_addresses" {
  value = module.vpc_ireland.public_subnet_addresses
}

output "ireland_unused_subnet_addresses" {
  value = module.vpc_ireland.unused_subnet_addresses
}
