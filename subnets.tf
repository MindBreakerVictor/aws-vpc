module "subnet_addresses" {
  source = "./subnet-addresses"

  ipv4_cidr_block      = var.main_cidr_block
  availability_zones   = local.azs_count
  private_subnets_only = var.private_subnets_only
  subnetting_algorithm = var.subnetting_algorithm
}
