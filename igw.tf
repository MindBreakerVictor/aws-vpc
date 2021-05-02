resource "aws_internet_gateway" "igw" {
  count = !var.private_subnets_only || var.force_internet_gateway ? 1 : 0

  vpc_id = aws_vpc.vpc.id

  tags = merge(var.tags, { Name = "${local.derived_prefix}-igw" })
}
