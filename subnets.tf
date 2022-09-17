module "subnet_addresses" {
  source = "./modules/subnet-addresses"

  ipv4_cidr_block      = var.main_cidr_block
  availability_zones   = local.azs_count
  private_subnets_only = var.private_subnets_only
  subnetting_algorithm = var.subnetting_algorithm
}

resource "aws_subnet" "private" {
  for_each = {
    for i in range(0, local.azs_count) : local.availability_zones[i] => {
      index      = i + 1
      cidr_block = module.subnet_addresses.private_subnet_addresses[i]
    }
  }

  vpc_id            = local.vpc_id
  cidr_block        = each.value["cidr_block"]
  availability_zone = each.key

  assign_ipv6_address_on_creation = var.ipv6_cidr_block

  tags = merge(var.tags, {
    Name        = "${var.name}-private-${each.value["index"]}"
    NetworkType = "private"
  })
}
