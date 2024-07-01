locals {
  enabled = module.this.enabled

  vpc_flow_logs_enabled = local.enabled && var.vpc_flow_logs_enabled
}

module "vpc" {
  source  = "aws-ia/vpc/aws"
  version = "3.1.0"

  name       = module.this.id
  cidr_block = var.cidr_block
  az_count   = var.az_count
  subnets    = var.subnets

  tags = module.this.tags
}

output "debug_vpc" {
  value = module.vpc
}

output "debug_tags" {
  value = module.this.tags
}
