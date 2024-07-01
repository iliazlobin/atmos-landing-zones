locals {
  resource_share_principles = var.resource_share_principles != null ? var.resource_share_principles : []
  account_names = [for v in local.resource_share_principles
    : module.account_map.outputs.account_info_map[format("%s-%s", v["tenant"], v["stage"])].id if can(module.account_map.outputs.account_info_map[format("%s-%s", v["tenant"], v["stage"])].id)
  ]
}

resource "aws_ram_resource_share" "this" {
  count                     = var.resource_share_principles != null ? 1 : 0
  name                      = module.this.id
  allow_external_principals = false

  tags = module.this.tags
}

resource "aws_ram_resource_association" "this" {
  count              = var.resource_share_principles != null ? 1 : 0
  resource_arn       = awscc_networkmanager_core_network.this.core_network_arn
  resource_share_arn = aws_ram_resource_share.this[0].arn
}

resource "aws_ram_principal_association" "this" {
  for_each           = toset(local.account_names)
  principal          = each.key
  resource_share_arn = aws_ram_resource_share.this[0].arn
}
