resource "aws_vpc_endpoint" "gateway" {
  for_each = local.service_gateway_endpoints

  vpc_id            = local.vpc_id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.${each.key}"
  vpc_endpoint_type = "Gateway"

  tags = merge(var.tags, { Name = "${local.derived_prefix}-${each.key}-gw-endpoint" })
}

resource "aws_vpc_endpoint_route_table_association" "gateway" {
  for_each = { for vpce_rtb_assoc in local.vpce_rtb_associations : "${vpce_rtb_assoc.service}-${vpce_rtb_assoc.rtb}" => vpce_rtb_assoc }

  vpc_endpoint_id = each.value.vpce_id
  route_table_id  = each.value.rtb_id
}
