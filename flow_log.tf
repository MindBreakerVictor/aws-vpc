module "flow_log" {
  count = var.flow_logs_config != null ? 1 : 0

  source = "./modules/flow-log"

  name_prefix = local.derived_prefix

  vpc_id                   = local.vpc_id
  logs_destination         = lookup(var.flow_logs_config, "destination", "cloud-watch-logs")
  retention_in_days        = lookup(var.flow_logs_config, "retention", 30)
  max_aggregation_interval = lookup(var.flow_logs_config, "aggregation_interval", 600)
  kms_key_id               = lookup(var.flow_logs_config, "kms_key_id", null)

  s3_tiering = lookup(var.flow_logs_config, "s3_tiering", {
    archive_access      = 90
    deep_archive_access = 180
  })

  tags = var.tags
}
