data "aws_availability_zones" "available" {}

locals {
  ### Private locals - Helpers for defining other locals
  _azs           = data.aws_availability_zones.available.names
  _azs_count     = min(var.availability_zones_count, length(local._azs))
  _subnets_count = local._azs_count * (var.private_subnets_only ? 1 : 2)

  _smallest_bits_to_extend_the_prefix               = floor(log(local._subnets_count, 2)) # Greatest value N for which 2 ^ N is smaller than the number of subnets
  _greatest_bits_to_extend_the_prefix               = ceil(log(local._subnets_count, 2)) # Smallest value N for which 2 ^ N is bigger than the number of subnets
  _greatest_power_of_two_smaller_than_subnets_count = pow(2, local._smallest_bits_to_extend_the_prefix)
  _smallest_power_of_two_greater_than_subnets_count = pow(2, local._greatest_bits_to_extend_the_prefix)

  _biggest_cidr_blocks = [
    for netnum in range(0, local._greatest_power_of_two_smaller_than_subnets_count) : cidrsubnet(var.main_cidr_block, local._smallest_bits_to_extend_the_prefix, netnum)
  ]

  # After the initial equal split of VPC IPv4 CIDR block if we don't have enough subnet addresses for each subnet,
  # we split, starting from the end of the initial list, further to get enough subnet addresses for each subnet.
  _cidr_blocks_to_split = reverse(slice(reverse(local._biggest_cidr_blocks), 0, local._subnets_count - length(local._biggest_cidr_blocks)))

  ### Public locals - Used anywhere in the module

  # Availability zones in which VPC subnets will be created
  availability_zones = toset(slice(local._azs, 0, local._azs_count))

  # Subnet addresses to be used for creating VPC subnets
  subnet_addresses = var.subnetting_algorithm == "nowaste" ? concat(
    slice(local._biggest_cidr_blocks, 0, length(local._biggest_cidr_blocks) - length(local._cidr_blocks_to_split)),
    flatten([for cidr_block in local._cidr_blocks_to_split : cidrsubnets(cidr_block, 1, 1)])
  ) : [
    for netnum in range(0, local._subnets_count) : cidrsubnet(var.main_cidr_block, local._greatest_bits_to_extend_the_prefix, netnum)
  ]

  private_subnet_addresses = slice(local.subnet_addresses, 0, local._azs_count)
  public_subnet_addresses  = slice(local.subnet_addresses, local._azs_count, length(local.subnet_addresses))

  # Unused subnet addresses - when algorithm is "equalsplit"
  unused_subnet_addresses = var.subnetting_algorithm == "nowaste" ? [] : [
    for netnum in range(length(local.subnet_addresses), local._smallest_power_of_two_greater_than_subnets_count) :
    cidrsubnet(var.main_cidr_block, local._greatest_bits_to_extend_the_prefix, netnum)
  ]
}

# Debug
# output "availability_zones" {
#   value = local.availability_zones
# }

# output "azs_count" {
#   value = local._azs_count
# }
