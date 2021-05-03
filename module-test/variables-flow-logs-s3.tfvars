private_subnets_only = true

flow_logs_config = {
  retention            = 60
  aggregation_interval = 60
  destination          = "s3"
}
