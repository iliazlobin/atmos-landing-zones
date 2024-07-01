locals {
  enabled = module.this.enabled
}

resource "awscc_networkmanager_global_network" "this" {
  description = "Global WAN network"
  tags        = module.this.tags_as_list_of_maps
}

resource "awscc_networkmanager_core_network" "this" {
  description       = "Core WAN network"
  global_network_id = awscc_networkmanager_global_network.this.id
  policy_document   = data.aws_networkmanager_core_network_policy_document.this.json
  tags              = module.this.tags_as_list_of_maps
}

data "aws_networkmanager_core_network_policy_document" "this" {
  core_network_configuration {
    asn_ranges         = var.asn_ranges
    inside_cidr_blocks = var.inside_cidr_blocks
    vpn_ecmp_support   = var.vpn_ecmp_support

    dynamic "edge_locations" {
      for_each = var.edge_locations
      content {
        location           = edge_locations.value["location"]
        asn                = can(edge_locations.value["asn"]) ? edge_locations.value["asn"] : null
        inside_cidr_blocks = can(edge_locations.value["inside_cidr_blocks"]) ? edge_locations.value["inside_cidr_blocks"] : null
      }
    }
  }

  dynamic "segments" {
    for_each = var.segments
    content {
      name                          = segments.key
      allow_filter                  = can(segments.value["allow_filter"]) ? segments.value["allow_filter"] : null
      deny_filter                   = can(segments.value["deny_filter"]) ? segments.value["deny_filter"] : null
      description                   = can(segments.value["description"]) ? segments.value["description"] : null
      edge_locations                = can(segments.value["edge_locations"]) ? segments.value["edge_locations"] : null
      isolate_attachments           = can(segments.value["isolate_attachments"]) ? segments.value["isolate_attachments"] : null
      require_attachment_acceptance = can(segments.value["require_attachment_acceptance"]) ? segments.value["require_attachment_acceptance"] : null
    }
  }

  dynamic "segment_actions" {
    for_each = var.segment_actions
    content {
      segment           = can(segment_actions.value["segment"]) ? segment_actions.value["segment"] : null
      action            = segment_actions.value["action"]
      description       = can(segment_actions.value["description"]) ? segment_actions.value["description"] : null
      destinations      = can(segment_actions.value["destinations"]) ? segment_actions.value["destinations"] : null
      mode              = can(segment_actions.value["mode"]) ? segment_actions.value["mode"] : null
      share_with        = can(segment_actions.value["share_with"]) ? segment_actions.value["share_with"] : null
      share_with_except = can(segment_actions.value["share_with_except"]) ? segment_actions.value["share_with_except"] : null
    }
  }

  dynamic "attachment_policies" {
    for_each = var.attachment_policies
    content {

      action {
        association_method = attachment_policies.value["action"]["association_method"]
        segment            = can(attachment_policies.value["action"]["segment"]) ? (attachment_policies.value["action"]["segment"]) : null
        tag_value_of_key   = can(attachment_policies.value["action"]["tag_value_of_key"]) ? attachment_policies.value["action"]["tag_value_of_key"] : null
        require_acceptance = can(attachment_policies.value["action"]["require_acceptance"]) ? attachment_policies.value["action"]["require_acceptance"] : null
      }

      condition_logic = can(attachment_policies.value["condition_logic"]) ? attachment_policies.value["condition_logic"] : null

      dynamic "conditions" {
        for_each = attachment_policies.value["conditions"]
        content {
          type     = conditions.value["type"]
          operator = can(conditions.value["operator"]) ? conditions.value["operator"] : null
          key      = can(conditions.value["key"]) ? conditions.value["key"] : null
          value    = can(conditions.value["value"]) ? conditions.value["value"] : null
        }
      }

      description = can(attachment_policies.value["description"]) ? attachment_policies.value["description"] : null
      rule_number = attachment_policies.value["rule_number"]
    }
  }
}
