resource "aws_internet_gateway" "igw" {
  count = var.mode != "none" ? 1 : 0

  vpc_id = var.vpc.id

  tags = merge(var.tags, { Name = "${var.vpc.name}" })
}

locals {
  azs       = keys(var.azs_cidr_blocks)
  azs_count = length(local.azs)

  nat_gateways_count = {
    one-az   = min(local.azs_count, 1)
    failover = min(local.azs_count, 2)
    ha       = local.azs_count
  }

  nat_gateway_azs = slice(local.azs, 0, local.nat_gateways_count[var.nat_gateway_setup])
}
