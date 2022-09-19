output "subnets" {
  value = {
    for az, subnet in aws_subnet.public : subnet.id => {
      ipv4_cidr_block   = subnet.cidr_block
      availability_zone = az
      route_table_id    = aws_route_table.public[0].id
    }
  }
}

output "nat_gateways_ids" {
  value = { for az, nat_gw in aws_nat_gateway.nat : az => nat_gw.id }
}
