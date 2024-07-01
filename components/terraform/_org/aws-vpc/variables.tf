variable "region" {
  type        = string
  description = "AWS Region"
}

variable "cidr_block" {
  type = string
}

variable "az_count" {
  type = number
}

variable "subnets" {
  type = any
}

variable "vpc_flow_logs_enabled" {
  type        = bool
  description = "Enable or disable the VPC Flow Logs"
  default     = true
}

variable "vpc_flow_logs_traffic_type" {
  type        = string
  description = "The type of traffic to capture. Valid values: `ACCEPT`, `REJECT`, `ALL`"
  default     = "ALL"
}

variable "vpc_flow_logs_log_destination_type" {
  type        = string
  description = "The type of the logging destination. Valid values: `cloud-watch-logs`, `s3`"
  default     = "s3"
}

variable "vpc_flow_logs_bucket_environment_name" {
  type        = string
  description = "The name of the environment where the VPC Flow Logs bucket is provisioned"
  default     = ""
}

variable "vpc_flow_logs_bucket_stage_name" {
  type        = string
  description = "The stage (account) name where the VPC Flow Logs bucket is provisioned"
  default     = ""
}

variable "vpc_flow_logs_bucket_tenant_name" {
  type        = string
  description = <<-EOT
  The name of the tenant where the VPC Flow Logs bucket is provisioned.

  If the `tenant` label is not used, leave this as `null`.
  EOT
  default     = null
}
