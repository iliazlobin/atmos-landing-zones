module "vpc" {
  source  = "cloudposse/stack-config/yaml//modules/remote-state"
  version = "1.1.1"

  component = "vpc"

  context = module.this.context
}

module "account_map" {
  source  = "cloudposse/stack-config/yaml//modules/remote-state"
  version = "1.1.1"

  component   = "account-map"
  environment = var.account_map_environment_name
  stage       = var.account_map_stage_name
  tenant      = var.account_map_tenant_name

  context = module.this.context
}
