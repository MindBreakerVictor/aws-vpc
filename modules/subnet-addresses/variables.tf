variable "ipv4_cidr_block" {
  type        = string
  description = "IPv4 CIDR block to use for subnetting."

  validation {
    condition     = try(regex("^([1-9]|([1-9][0-9])|(1[0-9][0-9])|(2[0-4][0-9])|(25[0-5]))[.]((0|[1-9]|([1-9][0-9])|(1[0-9][0-9])|(2[0-4][0-9])|(25[0-5]))[.]){2}(0|[1-9]|([1-9][0-9])|(1[0-9][0-9])|(2[0-4][0-9])|(25[0-5]))/((1[6-9])|(2[0-8]))$", var.ipv4_cidr_block) != "", false)
    error_message = "Invalid IPv4 CIDR block. Netmask must be between /28 and /16."
  }
}

variable "availability_zones" {
  type        = number
  description = "Number of Availability Zones for which to create subnets."
}

variable "private_subnets_only" {
  type        = bool
  description = "Whether to split the given IPv4 CIDR block only for private subnets."
}

variable "subnetting_algorithm" {
  type        = string
  description = <<EOF
Algorithm type for subnetting the VPC IPv4 CIDR blocks.
Supported algorithms:
* nowaste - Use the whole CIDR block, leaving no subnet addresses unused.
            It attempts an equal split. When the number of subnets is not a power of 2, the last subnets will have bigger prefix lengths
            Ie. Less usable host IPs
* equalsplit - The subnets will be split equally - ie. same prefix length
               This will result in unused subnet addresses when the number of requested subnets is not a power of 2.
EOF

  validation {
    condition     = contains(["nowaste", "equalsplit"], var.subnetting_algorithm)
    error_message = "Invalid subnetting algorithm. Valid values: nowaste, equalsplit."
  }
}
