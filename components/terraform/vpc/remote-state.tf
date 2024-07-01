module "vpc_flow_logs_bucket" {
  count = var.vpc_flow_logs_enabled ? 1 : 0

  source  = "cloudposse/stack-config/yaml//modules/remote-state"
  version = "1.0.0"

  tenant      = "core"
  environment = "gbl"
  stage       = "audit"
  component   = "vpc-flow-logs-bucket"

  context = module.this.context
}

module "cloud_wan" {
  source  = "cloudposse/stack-config/yaml//modules/remote-state"
  version = "1.0.0"

  tenant      = "core"
  environment = "gbl"
  stage       = "network"
  component   = "cloud-wan"

  context = module.this.context
}
