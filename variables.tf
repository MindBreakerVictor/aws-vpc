# General
variable "name" {
  type        = string
  description = "VPC name."
}

# VPC
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

# Subnets
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

  default = "nowaste"

  validation {
    condition     = contains(["nowaste", "equalsplit"], var.subnetting_algorithm)
    error_message = "Invalid subnetting algorithm. Valid values: nowaste, equalsplit."
  }
}

variable "subnets" {
  type = object({
    private = list(string)
    public  = list(string)
  })

  description = <<EOT
List of IPv4 CIDR blocks to use for each subnet, both private and public.
The # of subnets created is not decide by the length of the `private` & `public` lists, but rather the value of `availability_zones_count`,
but no more than the number of AZs available in the AWS Region where the VPC is created.
ie. min(var.availability_zones_count, length(data.aws_availability_zones.available.names))

If `private_subnets_only` is `true`, the `public` list can be passed as null or empty list.
By default, this variables is `null`, which means the subnets are computed by the internal algorithms, controlled by `subnetting_algorithm` variable.
EOT

  default = null
}

variable "private_subnets_only" {
  type        = bool
  description = "Whether to create only private subnets from VPC IPv4 CIDR block."
  default     = false
}

# Network ACLs
variable "private_nacl_rules" {
  type        = any # Terraform doesn't yet support optional attributes in objects
  description = "Inbound & outbound Network ACL rules for private subnets."
  default     = {}

  # validation {
  #   condition     = (var.private_nacl_rules == {} ||
  #     (length(lookup(var.private_nacl_rules, "ingress", [])) > 0 && length([
  #       for rule in var.private_nacl_rules["ingress"] : true
  #       if length([
  #         for key
  #       ]) == length(keys(rule))
  #     ]) == length(var.private_nacl_rules["ingress"])) ||
  #     (length(lookup(var.private_nacl_rules, "egress", [])) > 0 && true)
  #   )
  #   error_message = "value"
  # }
}

variable "public_nacl_rules" {
  type        = any # Terraform doesn't yet support optional attributes in objects
  description = "Inbound & outbound Network ACL rules for public subnets."
  default     = {}
}

# NAT Gateways & Internet Gateway
variable "nat_gateway_setup" {
  type        = string
  description = "NAT Gateway setup. Available options: one-az, failover, ha"
  default     = "ha"

  validation {
    condition     = contains(["one-az", "failover", "ha"], var.nat_gateway_setup)
    error_message = "NAT Gateway setups available are: one-az, failover, ha."
  }
}

variable "force_internet_gateway" {
  type        = bool
  description = "Force creation of an Internet Gateway for a VPC with only private subnets. Required if an AWS Global Accelerator is pointing to a private resource in the VPC."
  default     = false
}

# VPC Flow Logs
variable "flow_logs_config" {
  # type        = object({
  #   destination          = string
  #   retention            = optional(number)
  #   aggregation_interval = optional(number)
  #   log_format           = optional(string)
  #   kms_key_id           = optional(string)
  #   s3_tiering           = optional(object({
  #     archive_access      = optional(number)
  #     deep_archive_access = optional(number)
  #   }))
  # })
  type        = any # Because map values have different types.
  description = <<EOF
Config block for VPC Flow Logs. It must be a map with the following optional keys: destination, retention, aggregation_interval, kms_key_id.

Properties allowed values:
  destination          => "cloud-watch-logs" or "s3"
                          Default: "cloud-watch-logs"
  retention            => 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653, 0 (indefinetely)
                          Default: 30 (days)
                          Valid only for CloudWatch destination
  aggregation_interval => 60 or 600
                          Default: 600
  log_format           => Check AWS documentation
  kms_key_id           => ARN of a CMK in AWS KMS
                          Default: AWS managed key
  s3_tiering           => configuration for S3 Intelligent-Tiering
                          Default: Archive access after 90 days & Deep Archive Access after 180 days
                          Pass this as `null` or with both properties set to 0 to disable S3 Intelligent-Tiering
    archive_access       => Days after which data is tiered to ARCHIVE_ACCESS
                            Default: 90
                            Pass as 0 to disable ARCHIVE_ACCESS tiering
    deep_archive_access  => Days after which data is tiered to DEEP_ARCHIVE_ACCESS
                            Default: 180
                            Pass as 0 to disable DEEP_ARCHIVE_ACCESS tiering

Pass the variable as null to disable flow logs.
EOF

  default = {} #null

  validation {
    condition = try(length([
      for k in keys(var.flow_logs_config) : true
      if contains(["destination", "retention", "aggregation_interval", "log_format", "kms_key_id", "s3_tiering"], k)
    ]) == length(var.flow_logs_config), var.flow_logs_config == null)
    error_message = "Invalid key present in flow logs config."
  }

  # validation {
  #   condition     = contains(["cloud-watch-logs", "s3"], var.flow_logs_config.destination)
  #   error_message = "VPC flow logs destination must be either cloud-watch-logs or s3."
  # }

  # validation {
  #   condition     = try(contains([1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653, 0], var.flow_logs_config.retention), true)
  #   error_message = "Invalid retention period for VPC flow logs in CloudWatch destination."
  # }

  # validation {
  #   condition     = try(contains([60, 600], var.flow_logs_config.aggregation_interval), true)
  #   error_message = "Invalid aggregation interval for VPC flow logs."
  # }
}

variable "tags" {
  type        = map(string)
  description = "Common tags for all resources created by this module. Reserved tag keys: Name, net/type"
}
