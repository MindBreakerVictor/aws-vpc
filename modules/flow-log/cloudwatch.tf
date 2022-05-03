data "aws_iam_policy_document" "vpc_flow_logs" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
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

    resources = ["*"]
  }
}

resource "aws_iam_role" "cw" {
  count = var.logs_destination == "cloud-watch-logs" ? 1 : 0

  name               = local.name
  assume_role_policy = data.aws_iam_policy_document.vpc_flow_logs.json

  tags = local.tags
}

resource "aws_iam_role_policy" "cw" {
  count = var.logs_destination == "cloud-watch-logs" ? 1 : 0

  name   = "cloud_watch_logs"
  role   = aws_iam_role.cw[count.index].id
  policy = data.aws_iam_policy_document.cw.json
}

resource "aws_cloudwatch_log_group" "vpc_flow_logs" {
  count = var.logs_destination == "cloud-watch-logs" ? 1 : 0

  name              = local.name
  retention_in_days = var.retention_in_days
  kms_key_id        = var.kms_key_id

  tags = local.tags
}
