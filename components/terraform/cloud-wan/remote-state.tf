module "account_map" {
  source  = "cloudposse/stack-config/yaml//modules/remote-state"
  version = "1.0.0"

  tenant      = "core"
  environment = "gbl"
  stage       = "root"
  component   = "account-map"

  context = module.this.context
}

# module "vpc" {
#   for_each = var.resource_share_principles

#   source  = "cloudposse/stack-config/yaml//modules/remote-state"
#   version = "1.0.0"

#   component   = "vpc"
#   environment = each.key["environment"]
#   stage       = each.key["stage"]
#   tenant      = each.key["tenant"]

#   context = module.this.context
# }
