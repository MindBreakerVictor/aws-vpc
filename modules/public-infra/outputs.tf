output "nat_gateways_ids" {
  value = { for az, nat_gw in aws_nat_gateway.nat : az => nat_gw.id }
}
