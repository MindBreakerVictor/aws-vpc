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
