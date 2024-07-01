locals {
  gw_to_core_routes_default = [for id in module.subnets.gw_route_table_ids
    : {
        "route_table_id" = id,
        "destination_cidr_block" = "0.0.0.0/0"
      } if var.cloud_wan_enabled && length(var.clod_wan_route_cidrs) == 0
  ]
  private_to_core_routes_default = [for id in module.subnets.private_route_table_ids
    : {
        "route_table_id" = id,
        "destination_cidr_block" = "0.0.0.0/0"
      } if var.cloud_wan_enabled && length(var.clod_wan_route_cidrs) == 0
  ]
  private_to_core_routes_cidrs = flatten([for id in module.subnets.private_route_table_ids
    : [for cidr in var.clod_wan_route_cidrs
      : {
          "route_table_id" = id,
          "destination_cidr_block" = cidr
        } if var.cloud_wan_enabled && length(var.clod_wan_route_cidrs) > 0
    ]
  ])
  private_to_core_routes = concat(local.private_to_core_routes_default, local.private_to_core_routes_cidrs)
}

resource "aws_route" "private_to_core_network" {
  count = length(local.private_to_core_routes)

  route_table_id         = local.private_to_core_routes[count.index]["route_table_id"]
  destination_cidr_block = local.private_to_core_routes[count.index]["destination_cidr_block"]
  core_network_arn       = module.cloud_wan.outputs.core_network_arn
}

resource "aws_route" "gw_to_core_network" {
  count = length(local.gw_to_core_routes_default)

  route_table_id         = local.gw_to_core_routes_default[count.index]["route_table_id"]
  destination_cidr_block = local.gw_to_core_routes_default[count.index]["destination_cidr_block"]
  core_network_arn       = module.cloud_wan.outputs.core_network_arn
}

resource "aws_networkmanager_vpc_attachment" "cwan_attachment" {
  count = var.cloud_wan_enabled ? 1 : 0

  core_network_id = module.cloud_wan.outputs.core_network_id

  vpc_arn     = module.vpc.vpc_arn
  subnet_arns = module.subnets.gw_subnet_arns

  tags = module.this.tags
}

variable "cloud_wan_enabled" {
  type    = bool
  default = false
}

variable "clod_wan_route_cidrs" {
  type = list(string)
  default = []
}
