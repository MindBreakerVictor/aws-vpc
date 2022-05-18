data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id

  s3_tiering = try(var.s3_tiering.archive_access != 0 || var.s3_tiering.deep_archive_access != 0, var.s3_tiering != null)

  name = "${var.name_prefix}-vpc-flow-logs"
  tags = merge(var.tags, { Name = local.name })
}
