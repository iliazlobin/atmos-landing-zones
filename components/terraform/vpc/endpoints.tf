locals {
  endpoints_enabled = length(module.subnets.service_subnet_ids) > 0
  endpoint_service_names = { for k, v in var.endpoint_service_names
    : k => v if local.endpoints_enabled
  }
}

output "debug_var_endpoint_service_names" {
  value = var.endpoint_service_names
}
output "debug_endpoint_service_names" {
  value = local.endpoint_service_names
}
output "debug_service_subnet_ids" {
  value = module.subnets.service_subnet_ids
}

resource "aws_vpc_endpoint" "endpoint" {
  for_each = local.endpoint_service_names

  vpc_id              = module.vpc.vpc_id
  service_name        = each.value.name
  vpc_endpoint_type   = each.value.type
  subnet_ids          = module.subnets.service_subnet_ids
  security_group_ids  = [aws_security_group.endpoints_vpc_sg[0].id]
  private_dns_enabled = each.value.private_dns
}

resource "aws_security_group" "endpoints_vpc_sg" {
  count = local.endpoints_enabled ? 1 : 0

  name        = module.this.id
  description = "Security Group for SSM connection"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Allowing HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Any traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = module.this.tags
}

variable "endpoint_service_names" {
  type    = any
  default = {}
}

output "endpoints" {
  value = aws_vpc_endpoint.endpoint.*
}
