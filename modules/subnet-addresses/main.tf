locals {
  subnets_count = var.availability_zones * (var.private_subnets_only ? 1 : 2)

  # nowaste
  nowaste_smallest_bits_to_extend_prefix = floor(log(local.subnets_count, 2)) # Greatest value N for which 2 ^ N < local.subnets_count

  ## Step 1
  nowaste_initial_cidr_blocks = [
    for netnum in range(0, pow(2, local.nowaste_smallest_bits_to_extend_prefix)) :
    cidrsubnet(var.ipv4_cidr_block, local.nowaste_smallest_bits_to_extend_prefix, netnum)
  ]

  ## Step 2
  nowaste_last_cidr_blocks_to_split = reverse(slice(reverse(local.nowaste_initial_cidr_blocks), 0, local.subnets_count - length(local.nowaste_initial_cidr_blocks)))
  nowaste_last_cidr_blocks_splitted = flatten([for net in local.nowaste_last_cidr_blocks_to_split : cidrsubnets(net, 1, 1)])

  ## Final
  nowaste_subnet_addresses = concat(
    slice(local.nowaste_initial_cidr_blocks, 0, length(local.nowaste_initial_cidr_blocks) - length(local.nowaste_last_cidr_blocks_to_split)),
    local.nowaste_last_cidr_blocks_splitted
  )

  # equalsplit

  ## Step 1
  equalsplit_biggest_bits_to_extend_prefix = ceil(log(local.subnets_count, 2)) # Smallest value N for which 2 ^ N > local.subnets_count
  equalsplit_possible_subnets              = pow(2, local.equalsplit_biggest_bits_to_extend_prefix)

  ## Final
  equalsplit_subnet_addresses = [
    for netnum in range(0, local.subnets_count) :
    cidrsubnet(var.ipv4_cidr_block, local.equalsplit_biggest_bits_to_extend_prefix, netnum)
  ]

  equalsplit_unused_subnet_addresses = [
    for netnum in range(local.subnets_count, local.equalsplit_possible_subnets) :
    cidrsubnet(var.ipv4_cidr_block, local.equalsplit_biggest_bits_to_extend_prefix, netnum)
  ]

  # Outputs
  subnet_addresses         = var.subnetting_algorithm == "nowaste" ? local.nowaste_subnet_addresses : local.equalsplit_subnet_addresses
  private_subnet_addresses = slice(local.subnet_addresses, 0, var.availability_zones)
  public_subnet_addresses  = slice(local.subnet_addresses, var.availability_zones, length(local.subnet_addresses))
  unused_subnet_addresses  = var.subnetting_algorithm == "nowaste" ? [] : local.equalsplit_unused_subnet_addresses
}
