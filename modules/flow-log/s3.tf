resource "aws_s3_bucket" "vpc_flow_logs" {
  count = var.logs_destination == "s3" ? 1 : 0

  bucket = local.name

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = var.kms_key_id == null ? "AES256" : "aws:kms"
        kms_master_key_id = var.kms_key_id
      }
    }
  }

  lifecycle_rule {
    id      = "expire"
    enabled = true

    expiration {
      days = var.retention_in_days
    }
  }

  tags = local.tags
}
