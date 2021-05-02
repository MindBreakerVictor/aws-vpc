resource "aws_eip" "nat" {
  depends_on = [aws_internet_gateway.igw]

  for_each = toset(local.nat_gateway_azs)

  vpc = true

  tags = merge(var.tags, { Name = "${local.derived_prefix}-nat-eip-${each.value}" })
}

resource "aws_nat_gateway" "nat" {
  for_each = toset(local.nat_gateway_azs)

  subnet_id     = aws_subnet.public_subnets[each.key].id
  allocation_id = aws_eip.nat[each.key].allocation_id

  tags = merge(var.tags, { Name = "${local.derived_prefix}-nat-${each.value}" })
}
