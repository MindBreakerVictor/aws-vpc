variable "subnetting_algorithm" {
  type    = string
  default = "nowaste"
}

variable "private_subnets_only" {
  type    = bool
  default = false
}

variable "nat_gateway_setup" {
  type    = string
  default = "ha"
}

variable "create_vpc_gateway_endpoints" {
  type    = bool
  default = true
}

variable "flow_logs_config" {
  type    = any
  default = {}
}
