data "aws_availability_zones" "available" {}

locals {
  ### Private locals - Helpers for defining other locals
  _azs = data.aws_availability_zones.available.names

  ### Public locals - Used anywhere in the module
  azs_count          = min(var.availability_zones_count, length(local._azs))
  availability_zones = toset(slice(local._azs, 0, local.azs_count))
}
