output "private_subnet_addresses" {
  value = module.subnet_addresses.private_subnet_addresses
}

output "public_subnet_addresses" {
  value = module.subnet_addresses.public_subnet_addresses
}

output "unused_subnet_addresses" {
  value = module.subnet_addresses.unused_subnet_addresses
}
