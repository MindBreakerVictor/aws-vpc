locals {
  name = "${var.name_prefix}-vpc-flow-logs"
  tags = merge(var.tags, { Name = local.name })
}
