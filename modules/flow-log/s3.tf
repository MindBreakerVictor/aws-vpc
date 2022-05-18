resource "aws_s3_bucket" "vpc_flow_logs" {
  count = var.logs_destination == "s3" ? 1 : 0

  bucket = local.name
  tags   = local.tags
}

resource "aws_s3_bucket_server_side_encryption_configuration" "vpc_flow_logs" {
  count = var.logs_destination == "s3" ? 1 : 0

  bucket                = aws_s3_bucket.vpc_flow_logs[0].id
  expected_bucket_owner = local.account_id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = var.kms_key_id == null ? "AES256" : "aws:kms"
      kms_master_key_id = var.kms_key_id
    }

    # Reduce cost when using SSE-KMS encryption algorithm
    # https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucket-key.html
    bucket_key_enabled = var.kms_key_id != null
  }
}

resource "aws_s3_bucket_versioning" "vpc_flow_logs" {
  count = var.logs_destination == "s3" ? 1 : 0

  bucket                = aws_s3_bucket.vpc_flow_logs[0].id
  expected_bucket_owner = local.account_id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_intelligent_tiering_configuration" "vpc_flow_logs" {
  count = var.logs_destination == "s3" && local.s3_tiering ? 1 : 0

  bucket = aws_s3_bucket.vpc_flow_logs[0].id
  name   = "VPCFlowLogs"
  status = "Enabled"

  dynamic "tiering" {
    for_each = var.s3_tiering.archive_access != 0 ? [1] : []

    content {
      access_tier = "ARCHIVE_ACCESS"
      days        = var.s3_tiering.archive_access == null ? 90 : var.s3_tiering.archive_access
    }
  }

  dynamic "tiering" {
    for_each = var.s3_tiering.deep_archive_access != 0 ? [1] : []

    content {
      access_tier = "DEEP_ARCHIVE_ACCESS"
      days        = var.s3_tiering.deep_archive_access == null ? 180 : var.s3_tiering.deep_archive_access
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "vpc_flow_logs" {
  count = var.logs_destination == "s3" && var.retention_in_days != 0 ? 1 : 0

  bucket                = aws_s3_bucket.vpc_flow_logs[0].id
  expected_bucket_owner = local.account_id

  rule {
    id     = "Expire"
    status = "Enabled"

    expiration {
      days = var.retention_in_days
    }
  }
}
