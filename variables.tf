variable "name" {
  type        = string
  description = "VPC name."
}

variable "environment" {
  type        = string
  description = "Name of the environment for which the VPC is used. Leave empty if no environment name is desired."
  default     = ""
}

variable "main_cidr_block" {
  type        = string
  description = "Main IPv4 CIDR block for the VPC."

  validation {
    condition     = try(regex("^([1-9]|([1-9][0-9])|(1[0-9][0-9])|(2[0-4][0-9])|(25[0-5]))[.]((0|[1-9]|([1-9][0-9])|(1[0-9][0-9])|(2[0-4][0-9])|(25[0-5]))[.]){2}(0|[1-9]|([1-9][0-9])|(1[0-9][0-9])|(2[0-4][0-9])|(25[0-5]))/((1[6-9])|(2[0-8]))$", var.main_cidr_block) != "", false)
    error_message = "Invalid main IPv4 CIDR block for VPC. Netmask must be between /28 and /16."
  }
}

variable "instance_tenancy" {
  type        = string
  description = "Tenancy of instances launched into the VPC. Dedicated or host tenancy cost at least 2$/h."
  default     = "default"

  validation {
    condition     = contains(["default", "dedicated", "host"], var.instance_tenancy)
    error_message = "Invalid VPC tenancy."
  }
}

variable "enable_dns_support" {
  type        = bool
  description = "Whether to enable DNS support in the VPC."
  default     = true
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "Whether to enable DNS hostnames in the VPC."
  default     = true
}

variable "ipv6_cidr_block" {
  type        = bool
  description = "Whether to request an Amazon-provider IPv6 CIDR block with /56 prefix length for the VPC."
  default     = false

  validation {
    condition     = !var.ipv6_cidr_block
    error_message = "IPv6 is not yet supported."
  }
}

variable "availability_zones_count" {
  type        = number
  description = "Number of Availability Zones to use for VPC subnets."
  default     = 3
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
  default     = "nowaste"

  validation {
    condition     = contains(["nowaste", "equalsplit"], var.subnetting_algorithm)
    error_message = "Invalid subnetting algorithm. Valid values: nowaste, equalsplit."
  }
}

variable "private_subnets_only" {
  type        = bool
  description = "Whether to create only private subnets from VPC IPv4 CIDR block."
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "Common tags for all resources created by this module. Reserved tag keys: Name, net/type"
}
