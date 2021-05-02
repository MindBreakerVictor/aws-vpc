resource "aws_route_table" "public" {
  count = var.private_subnets_only ? 0 : 1

  vpc_id = aws_vpc.vpc.id

  tags = merge(var.tags, { Name = "${local.derived_prefix}-public-rtb" })
}

resource "aws_route_table" "private" {
  for_each = !var.private_subnets_only && var.nat_gateway_setup == "ha" ? toset(local.availability_zones) : toset([""])

  vpc_id = aws_vpc.vpc.id

  tags = merge(var.tags, {
    Name = format("%s-private-rtb%s", local.derived_prefix, !var.private_subnets_only && var.nat_gateway_setup == "ha" ? "-${each.key}" : "")
  })
}
