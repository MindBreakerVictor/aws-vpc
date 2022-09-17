resource "aws_iam_role" "cw" {
  count = var.logs_destination == "cloud-watch-logs" ? 1 : 0

  name               = "${var.vpc.name}-vpc-flow-logs"
  assume_role_policy = data.aws_iam_policy_document.vpc_flow_logs.json

  tags = merge(var.tags, { Name = "${var.vpc.name}-vpc-flow-logs" })
}

resource "aws_iam_role_policy" "cw" {
  count = var.logs_destination == "cloud-watch-logs" ? 1 : 0

  name   = "cloud_watch_logs"
  role   = aws_iam_role.cw[count.index].id
  policy = data.aws_iam_policy_document.cw.json
}

resource "aws_cloudwatch_log_group" "vpc_flow_logs" {
  count = var.logs_destination == "cloud-watch-logs" ? 1 : 0

  name              = "/aws/vpc/${var.vpc.name}"
  retention_in_days = var.retention_in_days
  kms_key_id        = var.kms_key_id

  tags = merge(var.tags, { Name = "/aws/vpc/${var.vpc.name}" })
}
