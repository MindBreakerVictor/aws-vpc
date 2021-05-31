resource "aws_route_table" "public" {
  count = var.private_subnets_only ? 0 : 1

  vpc_id = aws_vpc.vpc.id

  tags = merge(var.tags, { Name = "${local.derived_prefix}-public-rtb" })
}

resource "aws_route_table" "private" {
  for_each = !var.private_subnets_only && var.nat_gateway_setup == "ha" ? toset(local.availability_zones) : toset(["private"])

  vpc_id = aws_vpc.vpc.id

  tags = merge(var.tags, {
    Name = format("%s-private-rtb%s", local.derived_prefix, !var.private_subnets_only && var.nat_gateway_setup == "ha" ? "-${each.key}" : "")
  })
}

resource "aws_route" "igw" {
  count = var.private_subnets_only ? 0 : 1

  route_table_id         = aws_route_table.public[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw[count.index].id
}

resource "aws_route" "nat" {
  for_each = var.private_subnets_only ? {} : aws_route_table.private

  route_table_id         = each.value.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = contains(["one-az", "failover"], var.nat_gateway_setup) ? aws_nat_gateway.nat[local.nat_gateway_azs[0]].id : aws_nat_gateway.nat[each.key].id
}
