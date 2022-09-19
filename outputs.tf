output "vpc_id" {
  value       = local.vpc_id
  description = "The VPC ID."
}

output "subnets" {
  value = {
    private = {
      for az, subnet in aws_subnet.private : subnet.id => {
        ipv4_cidr_block   = subnet.cidr_block
        availability_zone = az
        route_table_id    = try(aws_route_table.private[az].id, aws_route_table.private["private"].id)
      }
    }

    public = module.public_infra.subnets
  }

  description = "Map of both private & public subnets with IP CIDR block, associated route table & network ACL IDs as properties."
}

output "private_subnet_addresses" {
  value = local.custom_subnetting ? var.subnets.private : module.subnet_addresses.private_subnet_addresses
}

output "public_subnet_addresses" {
  value = local.custom_subnetting ? var.subnets.public : module.subnet_addresses.public_subnet_addresses
}

output "unused_subnet_addresses" {
  value = local.custom_subnetting ? null : module.subnet_addresses.unused_subnet_addresses
}
