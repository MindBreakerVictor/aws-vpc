resource "aws_subnet" "public" {
  for_each = var.mode != "public" ? {} : {
    for i in range(0, local.azs_count) : local.azs[i] => {
      index      = i + 1
      cidr_block = var.azs_cidr_blocks[local.azs[i]]
    }
  }

  vpc_id            = var.vpc.id
  cidr_block        = each.value["cidr_block"]
  availability_zone = each.key

  # assign_ipv6_address_on_creation = var.ipv6_cidr_block

  tags = merge(var.tags, {
    Name        = "${var.vpc.name}-public-${each.value["index"]}"
    NetworkType = "public"
  })
}
