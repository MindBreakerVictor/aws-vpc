resource "aws_flow_log" "vpc_flow_logs" {
  log_destination      = var.logs_destination == "cloud-watch-logs" ? aws_cloudwatch_log_group.vpc_flow_logs[0].arn : aws_s3_bucket.vpc_flow_logs[0].arn
  log_destination_type = var.logs_destination
  traffic_type         = "ALL"
  vpc_id               = var.vpc_id

  iam_role_arn = var.logs_destination == "cloud-watch-logs" ? aws_iam_role.cw[0].arn : null

  max_aggregation_interval = var.max_aggregation_interval

  tags = local.tags
}
