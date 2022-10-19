module "public_infra" {
  source = "./modules/public-infra"

  vpc = {
    id   = local.vpc_id
    name = var.name
  }

  mode = var.private_subnets_only ? (var.force_internet_gateway ? "igw-only" : "none") : "public"

  azs_cidr_blocks = {
    for i in range(0, length(module.subnet_addresses.public_subnet_addresses)) :
    local.availability_zones[i] => local.custom_subnetting ? var.subnets.public[i] : module.subnet_addresses.public_subnet_addresses[i]
  }

  nat_gateway_setup = var.nat_gateway_setup

  empty_network_acl = var.empty_network_acls

  tags = var.tags
}
