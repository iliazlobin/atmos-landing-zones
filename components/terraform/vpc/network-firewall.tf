locals {
  network_firewall_enabled = var.network_firewall_enabled && length(module.subnets.inspection_subnet_ids) > 0
  network_firewall_policies = var.network_firewall_policies
}

resource "aws_networkfirewall_firewall" "this" {
  count = local.network_firewall_enabled ? 1 : 0

  name                              = module.this.id
  vpc_id = module.vpc.vpc_id
  firewall_policy_arn               = aws_networkfirewall_firewall_policy.this[0].arn

  dynamic "subnet_mapping" {
    for_each = toset(module.subnets.inspection_subnet_ids)
    content {
      subnet_id = subnet_mapping.value
    }
  }

  tags = module.this.tags
}

output "network_firweall_arn" {
  value = aws_networkfirewall_firewall.this.*.arn
}

output "network_firweall_name" {
  value = aws_networkfirewall_firewall.this.*.name
}

output "network_firweall_id" {
  value = aws_networkfirewall_firewall.this.*.id
}

output "network_firweall_status" {
  value = aws_networkfirewall_firewall.this.*.firewall_status
}

output "network_firweall_subnet_mapping" {
  value = aws_networkfirewall_firewall.this.*.subnet_mapping
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkfirewall_firewall_policy#encryption-configuration
resource "aws_networkfirewall_firewall_policy" "this" {
  count = local.network_firewall_enabled ? 1 : 0
  # for_each = local.network_firewall_policies

  name = module.this.id # TODO: for_each

  firewall_policy {
    stateless_default_actions          = ["aws:forward_to_sfe"]
    stateless_fragment_default_actions = ["aws:forward_to_sfe"]
    stateful_rule_group_reference {
      resource_arn = aws_networkfirewall_rule_group.this[0].arn
    }
    # stateful_rule_group_reference {
    #   resource_arn = aws_networkfirewall_rule_group.domain_allow_stateful_rule_group_nvirginia.arn
    # }
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/networkfirewall_rule_group
resource "aws_networkfirewall_rule_group" "this" {
  count = local.network_firewall_enabled ? 1 : 0
  # for_each = local.network_firewall_policies

  capacity = 100
  name     = module.this.id # TODO: for_each
  type     = "STATEFUL"

  rule_group {
    rules_source {
      stateful_rule {
        action = "ALERT"
        header {
          direction        = "ANY"
          protocol         = "ICMP"
          destination      = "ANY"
          source           = "ANY"
          destination_port = "ANY"
          source_port      = "ANY"
        }
        rule_option {
          keyword = "sid:1"
        }
      }
    }
  }
}

variable "network_firewall_enabled" {
  type = bool
  default = false
}

variable "network_firewall_policies" {
  type = any
  default = {}
}
