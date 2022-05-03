module "flow_log" {
  count = var.flow_logs_config != null ? 1 : 0

  source = "./modules/flow-log"

  name_prefix = local.derived_prefix

  vpc_id                   = aws_vpc.vpc.id
  logs_destination         = lookup(var.flow_logs_config, "destination", "cloud-watch-logs")
  retention_in_days        = lookup(var.flow_logs_config, "retention", 30)
  max_aggregation_interval = lookup(var.flow_logs_config, "aggregation_interval", 600)
  kms_key_id               = lookup(var.flow_logs_config, "kms_key_id", null)

  tags = var.tags
}
