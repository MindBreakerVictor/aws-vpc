module "nowaste_private_subnets" {
  source = "../../modules/subnet-addresses"

  subnetting_algorithm = "nowaste"

  ipv4_cidr_block      = "10.0.0.0/16"
  availability_zones   = 3
  private_subnets_only = true
}

module "nowaste_public_subnets" {
  source = "../../modules/subnet-addresses"

  subnetting_algorithm = "nowaste"

  ipv4_cidr_block      = "10.0.0.0/16"
  availability_zones   = 6
  private_subnets_only = false
}

module "nowaste_power_of_two" {
  source = "../../modules/subnet-addresses"

  subnetting_algorithm = "nowaste"

  ipv4_cidr_block      = "10.0.0.0/16"
  availability_zones   = 4
  private_subnets_only = false
}

module "equalsplit_private_subnets" {
  source = "../../modules/subnet-addresses"

  subnetting_algorithm = "equalsplit"

  ipv4_cidr_block      = "10.0.0.0/16"
  availability_zones   = 3
  private_subnets_only = true
}

module "equalsplit_public_subnets" {
  source = "../../modules/subnet-addresses"

  subnetting_algorithm = "equalsplit"

  ipv4_cidr_block      = "10.0.0.0/16"
  availability_zones   = 6
  private_subnets_only = false
}

module "equalsplit_power_of_two" {
  source = "../../modules/subnet-addresses"

  subnetting_algorithm = "equalsplit"

  ipv4_cidr_block      = "10.0.0.0/16"
  availability_zones   = 4
  private_subnets_only = false
}
