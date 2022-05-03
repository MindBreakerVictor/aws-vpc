output "flow_logs_destination" {
  value = aws_flow_log.vpc_flow_logs.log_destination
}
