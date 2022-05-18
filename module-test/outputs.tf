output "nv_private_subnet_addresses" {
  value = local.nv_vpc ? module.vpc.private_subnet_addresses : []
}

output "nv_public_subnet_addresses" {
  value = local.nv_vpc ? module.vpc.public_subnet_addresses : []
}

output "nv_unused_subnet_addresses" {
  value = local.nv_vpc ? module.vpc.unused_subnet_addresses : []
}

output "six_azs_private_subnet_addresses" {
  value = local.nv_six_azs_vpc ? module.vpc_six_azs.private_subnet_addresses : []
}

output "six_azs_public_subnet_addresses" {
  value = local.nv_six_azs_vpc ? module.vpc_six_azs.public_subnet_addresses : []
}

output "six_azs_unused_subnet_addresses" {
  value = local.nv_six_azs_vpc ? module.vpc_six_azs.unused_subnet_addresses : []
}

output "frankfurt_private_subnet_addresses" {
  value = module.vpc_frankfurt.private_subnet_addresses
}

output "frankfurt_public_subnet_addresses" {
  value = module.vpc_frankfurt.public_subnet_addresses
}

output "frankfurt_unused_subnet_addresses" {
  value = module.vpc_frankfurt.unused_subnet_addresses
}
