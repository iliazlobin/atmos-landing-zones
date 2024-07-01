module "account_map" {
  source  = "cloudposse/stack-config/yaml//modules/remote-state"
  version = "1.0.0"

  component   = "account-map"
  environment = var.global_environment_name
  stage       = var.root_account_stage_name
  privileged  = var.privileged

  context = module.this.context
}
