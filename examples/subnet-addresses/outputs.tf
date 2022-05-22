output "nowaste_private_subnets" {
  value = {
    private_subnets = module.nowaste_private_subnets.private_subnet_addresses
    public_subnets  = module.nowaste_private_subnets.public_subnet_addresses
    unused_subnets  = module.nowaste_private_subnets.unused_subnet_addresses
  }
}

output "nowaste_public_subnets" {
  value = {
    private_subnets = module.nowaste_public_subnets.private_subnet_addresses
    public_subnets  = module.nowaste_public_subnets.public_subnet_addresses
    unused_subnets  = module.nowaste_public_subnets.unused_subnet_addresses
  }
}

output "nowaste_power_of_two" {
  value = {
    private_subnets = module.nowaste_power_of_two.private_subnet_addresses
    public_subnets  = module.nowaste_power_of_two.public_subnet_addresses
    unused_subnets  = module.nowaste_power_of_two.unused_subnet_addresses
  }
}

output "equalsplit_private_subnets" {
  value = {
    private_subnets = module.equalsplit_private_subnets.private_subnet_addresses
    public_subnets  = module.equalsplit_private_subnets.public_subnet_addresses
    unused_subnets  = module.equalsplit_private_subnets.unused_subnet_addresses
  }
}

output "equalsplit_public_subnets" {
  value = {
    private_subnets = module.equalsplit_public_subnets.private_subnet_addresses
    public_subnets  = module.equalsplit_public_subnets.public_subnet_addresses
    unused_subnets  = module.equalsplit_public_subnets.unused_subnet_addresses
  }
}

output "equalsplit_power_of_two" {
  value = {
    private_subnets = module.equalsplit_power_of_two.private_subnet_addresses
    public_subnets  = module.equalsplit_power_of_two.public_subnet_addresses
    unused_subnets  = module.equalsplit_power_of_two.unused_subnet_addresses
  }
}
