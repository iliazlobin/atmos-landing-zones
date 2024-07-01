variable "region" {
  type        = string
  description = "AWS Region"
}

variable "asn_ranges" {
  type        = any
  description = "(Required) - List of strings containing Autonomous System Numbers (ASNs) to assign to Core Network Edges. By default, the core network automatically assigns an ASN for each Core Network Edge but you can optionally define the ASN in the edge-locations for each Region. The ASN uses an array of integer ranges only from 64512 to 65534 and 4200000000 to 4294967294 expressed as a string like \"64512-65534\". No other ASN ranges can be used."
}

variable "inside_cidr_blocks" {
  type        = list(string)
  default     = null
  description = "(Optional) - The Classless Inter-Domain Routing (CIDR) block range used to create tunnels for AWS Transit Gateway Connect. The format is standard AWS CIDR range (for example, 10.0.1.0/24). You can optionally define the inside CIDR in the Core Network Edges section per Region. The minimum is a /24 for IPv4 or /64 for IPv6. You can provide multiple /24 subnets or a larger CIDR range. If you define a larger CIDR range, new Core Network Edges will be automatically assigned /24 and /64 subnets from the larger CIDR. an Inside CIDR block is required for attaching Connect attachments to a Core Network Edge."
}

variable "vpn_ecmp_support" {
  type        = bool
  default     = true
  description = "(Optional) - Indicates whether the core network forwards traffic over multiple equal-cost routes using VPN. The value can be either true or false. The default is true."
}

variable "segments" {
  type        = any
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/networkmanager_core_network_policy_document#segments"
}

variable "segment_actions" {
  type        = any
  default     = {}
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/networkmanager_core_network_policy_document#segment_actions"
}

variable "attachment_policies" {
  type        = any
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/networkmanager_core_network_policy_document#attachment_policies"
}

variable "edge_locations" {
  type        = any
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/networkmanager_core_network_policy_document#edge_locations"
}

variable "resource_share_principles" {
  type    = any
  default = null
}
