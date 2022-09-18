resource "aws_route_table" "private" {
  for_each = !var.private_subnets_only && var.nat_gateway_setup == "ha" ? toset(local.availability_zones) : toset(["private"])

  vpc_id = local.vpc_id

  tags = merge(var.tags, {
    Name = format("%s-private%s", var.name, !var.private_subnets_only && var.nat_gateway_setup == "ha" ? "-${each.key}" : "")
  })
}

resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private

  subnet_id      = each.value.id
  route_table_id = !var.private_subnets_only && var.nat_gateway_setup == "ha" ? aws_route_table.private[each.key].id : aws_route_table.private["private"].id
}

resource "aws_route" "nat" {
  for_each = var.private_subnets_only ? {} : aws_route_table.private

  route_table_id         = each.value.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.nat_gateway_setup == "ha" ? module.public_infra.nat_gateways_ids[each.key] : module.public_infra.nat_gateways_ids[local.availability_zones[0]]
}
