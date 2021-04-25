locals {
  subnets_count = var.availability_zones * (var.private_subnets_only ? 1 : 2)

  smallest_bits_to_extend_the_prefix               = floor(log(local.subnets_count, 2)) # Greatest value N for which 2 ^ N is smaller than the number of subnets
  greatest_bits_to_extend_the_prefix               = ceil(log(local.subnets_count, 2)) # Smallest value N for which 2 ^ N is bigger than the number of subnets
  greatest_power_of_two_smaller_than_subnets_count = pow(2, local.smallest_bits_to_extend_the_prefix)
  smallest_power_of_two_greater_than_subnets_count = pow(2, local.greatest_bits_to_extend_the_prefix)

  biggest_cidr_blocks = [
    for netnum in range(0, local.greatest_power_of_two_smaller_than_subnets_count) :
    cidrsubnet(var.ipv4_cidr_block, local.smallest_bits_to_extend_the_prefix, netnum)
  ]

  # After the initial equal split of VPC IPv4 CIDR block if we don't have enough subnet addresses for each subnet,
  # we split, starting from the end of the initial list, further to get enough subnet addresses for each subnet.
  # The result is reversed so the IPv4 CIDR blocks remain in order.
  cidr_blocks_to_split = reverse(slice(reverse(local.biggest_cidr_blocks), 0, local.subnets_count - length(local.biggest_cidr_blocks)))

  # Subnet addresses to be used for creating VPC subnets
  subnet_addresses = var.subnetting_algorithm == "nowaste" ? concat(
    slice(local.biggest_cidr_blocks, 0, length(local.biggest_cidr_blocks) - length(local.cidr_blocks_to_split)),
    flatten([for cidr_block in local.cidr_blocks_to_split : cidrsubnets(cidr_block, 1, 1)])
  ) : [
    for netnum in range(0, local.subnets_count) : cidrsubnet(var.ipv4_cidr_block, local.greatest_bits_to_extend_the_prefix, netnum)
  ]

  private_subnet_addresses = slice(local.subnet_addresses, 0, var.availability_zones)
  public_subnet_addresses  = slice(local.subnet_addresses, var.availability_zones, length(local.subnet_addresses))

  # Unused subnet addresses - when algorithm is "equalsplit"
  unused_subnet_addresses = var.subnetting_algorithm == "nowaste" ? [] : [
    for netnum in range(length(local.subnet_addresses), local.smallest_power_of_two_greater_than_subnets_count) :
    cidrsubnet(var.ipv4_cidr_block, local.greatest_bits_to_extend_the_prefix, netnum)
  ]
}
