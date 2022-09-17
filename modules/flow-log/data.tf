data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "vpc_flow_logs" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [local.account_id]
    }

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"

      # Classic egg-vs-chicken problem
      # No way to specify the exact VPC flow log ID, without using an "external" data source
      # to query AWS API and know when the flow log already exists and even that requires
      # 2 Terraform applies to set the policy right.
      values = ["arn:aws:ec2:${local.region}:${local.account_id}:vpc-flow-log/*"]
    }
  }
}

data "aws_iam_policy_document" "cw" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams"
    ]

    resources = ["*"] # tfsec:ignore:aws-iam-no-policy-wildcards
  }
}

locals {
  region     = data.aws_region.current.name
  account_id = data.aws_caller_identity.current.account_id

  s3_tiering = try(var.s3_tiering.archive_access != 0 || var.s3_tiering.deep_archive_access != 0, var.s3_tiering != null)
}
