resource "aws_eip" "nat" {
  depends_on = [aws_internet_gateway.igw]

  for_each = toset(local.nat_gateway_azs)

  domain = "vpc"

  tags = merge(var.tags, { Name = "${var.vpc.name}-nat-eip-${each.value}" })
}

resource "aws_nat_gateway" "nat" {
  for_each = toset(local.nat_gateway_azs)

  subnet_id     = aws_subnet.public[each.key].id
  allocation_id = aws_eip.nat[each.key].id

  tags = merge(var.tags, { Name = "${var.vpc.name}-${each.value}" })
}
