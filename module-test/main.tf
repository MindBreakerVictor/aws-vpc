module "vpc" {
  source = "../"

  name                     = "modtest"
  main_cidr_block          = "10.0.0.0/24"
  availability_zones_count = 4
  subnetting_algorithm     = var.subnetting_algorithm

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
  subnetting_algorithm     = var.subnetting_algorithm

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
  subnetting_algorithm     = var.subnetting_algorithm

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
# output "azs_count" {
#   value = module.vpc.azs_count
# }

output "subnet_addresses" {
  value = module.vpc.subnet_addresses
}

output "unused_subnet_addresses" {
  value = module.vpc.unused_subnet_addresses
}

# output "azs_count_six_azs" {
#   value = module.vpc_six_azs.azs_count
# }

output "subnet_addresses_six_azs" {
  value = module.vpc_six_azs.subnet_addresses
}

output "unused_subnet_addresses_six_azs" {
  value = module.vpc_six_azs.unused_subnet_addresses
}

# output "azs_count_ireland" {
#   value = module.vpc_ireland.azs_count
# }

output "subnet_addresses_ireland" {
  value = module.vpc_ireland.subnet_addresses
}

output "unused_subnet_addresses_ireland" {
  value = module.vpc_ireland.unused_subnet_addresses
}
