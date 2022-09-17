data "aws_region" "current" {}

data "aws_availability_zones" "available" {
  filter {
    name   = "zone-type"
    values = ["availability-zone"]
  }
}

locals {
  ### Private locals - Helpers for defining other locals
  _azs = data.aws_availability_zones.available.names

  ### Public locals - Used anywhere in the module
  vpc_id = aws_vpc.vpc.id

  azs_count          = min(var.availability_zones_count, length(local._azs))
  availability_zones = slice(local._azs, 0, local.azs_count)

  custom_subnetting = try(length(var.subnets.private) > 0 || length(var.subnets.public) > 0, false)

  private_route_tables = [for key, rtb in aws_route_table.private : {
    key = key
    id  = rtb.id
  }]

  service_gateway_endpoints = toset(["s3", "dynamodb"])

  vpc_gateway_endpoints = [for svc, endpoint in aws_vpc_endpoint.gateway : {
    service = svc
    id      = endpoint.id
  }]

  vpce_rtb_associations = [for pair in setproduct(local.vpc_gateway_endpoints, local.private_route_tables) : {
    service = pair[0].service
    rtb     = pair[1].key

    vpce_id = pair[0].id
    rtb_id  = pair[1].id
  }]
}
