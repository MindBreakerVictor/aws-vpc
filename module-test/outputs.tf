output "nv" {
  value = !local.nv_vpc ? null : {
    vpc_id  = module.vpc[0].vpc_id
    subnets = module.vpc[0].subnets

    private_subnet_addresses = module.vpc[0].private_subnet_addresses
    public_subnet_addresses  = module.vpc[0].public_subnet_addresses
    unused_subnet_addresses  = module.vpc[0].unused_subnet_addresses
  }
}

output "six_azs" {
  value = !local.nv_six_azs_vpc ? null : {
    vpc_id  = module.vpc_six_azs[0].vpc_id
    subnets = module.vpc_six_azs[0].subnets

    private_subnet_addresses = module.vpc_six_azs[0].private_subnet_addresses
    public_subnet_addresses  = module.vpc_six_azs[0].public_subnet_addresses
    unused_subnet_addresses  = module.vpc_six_azs[0].unused_subnet_addresses
  }
}

output "frankfurt" {
  value = {
    vpc_id  = module.vpc_frankfurt.vpc_id
    subnets = module.vpc_frankfurt.subnets

    private_subnet_addresses = module.vpc_frankfurt.private_subnet_addresses
    public_subnet_addresses  = module.vpc_frankfurt.public_subnet_addresses
    unused_subnet_addresses  = module.vpc_frankfurt.unused_subnet_addresses
  }
}
