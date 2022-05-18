module "public_infra" {
  source = "./modules/public-infra"

  derived_prefix = local.derived_prefix
  vpc_id         = local.vpc_id
  mode           = var.private_subnets_only ? (var.force_internet_gateway ? "igw-only" : "none") : "public"

  azs_cidr_blocks = {
    for i in range(0, length(module.subnet_addresses.public_subnet_addresses)) :
    local.availability_zones[i] => module.subnet_addresses.public_subnet_addresses[i]
  }

  nat_gateway_setup = var.nat_gateway_setup

  network_acl_rules = var.public_nacl_rules == {} ? local.defaults.public_nacl_rules : var.public_nacl_rules

  tags = var.tags
}
