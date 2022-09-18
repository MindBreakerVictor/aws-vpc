variable "vpc" {
  type = object({
    id   = string
    name = string
  })

  description = "VPC ID & name."
}

variable "logs_destination" {
  type        = string
  description = "Destination for the VPC Flow Logs. Allowed values: cloud-watch-logs or s3."

  validation {
    condition     = contains(["cloud-watch-logs", "s3"], var.logs_destination)
    error_message = "Invalid VPC Flow Logs destination."
  }
}

variable "retention_in_days" {
  type        = number
  description = "The number of days to keep the VPC Flow Logs. Allowed values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653 and 0."

  validation {
    condition     = contains([1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653, 0], var.retention_in_days)
    error_message = "Invalid VPC Flow Logs retention period."
  }
}

variable "s3_tiering" {
  type = object({
    archive_access      = number
    deep_archive_access = number
  })
  description = "Configuration of S3 Intelligent-Tiering when VPC flow logs are stored in S3."
}

variable "kms_key_id" {
  type        = string
  description = "AWS KMS' CMK id, to be used for encrypting the VPC Flow Logs. Set to null to use AWS managed keys."

  validation {
    condition     = try(length(regexall("^^arn:aws:kms:(us(-gov)?|ap|ca|cn|eu|sa)-(central|(north|south)?(east|west)?)-\\d:\\d{12}:key/[0-9a-f]{8}(-[0-9a-f]{4}){3}-[0-9a-f]{12}$", var.kms_key_id)) > 0, var.kms_key_id == null)
    error_message = "Invalid KMS key ARN."
  }
}

variable "max_aggregation_interval" {
  type        = number
  description = "The maximum interval of time during which a flow of packets is captured and aggregated into a flow log record. Valid values: 60 seconds & 600 seconds."
  default     = 600

  validation {
    condition     = contains([60, 600], var.max_aggregation_interval)
    error_message = "Invalid aggregation interval."
  }
}

variable "log_format" {
  type        = string
  description = "The fields to include in the flow log record, in the order in which they should appear."
  default     = null
}

variable "tags" {
  type = map(string)
}
