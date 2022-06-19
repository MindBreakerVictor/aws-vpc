resource "aws_route_table" "public" {
  count = var.mode != "public" ? 0 : 1

  vpc_id = var.vpc_id

  tags = merge(var.tags, { Name = "${var.derived_prefix}-public-rtb" })
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public[0].id
}

resource "aws_route" "igw" {
  count = var.mode != "public" ? 0 : 1

  route_table_id         = aws_route_table.public[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw[count.index].id
}
