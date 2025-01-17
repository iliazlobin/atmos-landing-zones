variable "region" {
  type        = string
  description = "AWS Region"
}

variable "availability_zones" {
  type        = list(string)
  description = <<-EOT
    List of Availability Zones (AZs) where subnets will be created. Ignored when `availability_zone_ids` is set.
    The order of zones in the list ***must be stable*** or else Terraform will continually make changes.
    If no AZs are specified, then `max_subnet_count` AZs will be selected in alphabetical order.
    If `max_subnet_count > 0` and `length(var.availability_zones) > max_subnet_count`, the list
    will be truncated. We recommend setting `availability_zones` and `max_subnet_count` explicitly as constant
    (not computed) values for predictability, consistency, and stability.
    EOT
  default     = []
}

variable "availability_zone_ids" {
  type        = list(string)
  description = <<-EOT
    List of Availability Zones IDs where subnets will be created. Overrides `availability_zones`.
    Useful in some regions when using only some AZs and you want to use the same ones across multiple accounts.
    EOT
  default     = []
}

variable "ipv4_primary_cidr_block" {
  type        = string
  description = <<-EOT
    The primary IPv4 CIDR block for the VPC.
    Either `ipv4_primary_cidr_block` or `ipv4_primary_cidr_block_association` must be set, but not both.
    EOT
  default     = null
}

variable "ipv4_cidrs" {
  type = object({
    gw  = optional(list(string))
    inspection  = optional(list(string))
    service  = optional(list(string))
    protected  = optional(list(string))
    public  = optional(list(string))
    private = optional(list(string))
    data  = optional(list(string))
  })
  description = <<-EOT
    Lists of CIDRs to assign to subnets. Order of CIDRs in the lists must not change over time.
    Lists may contain more CIDRs than needed.
    EOT
  default     = {}
  # validation {
  #   condition     = length(var.ipv4_cidrs) < 2
  #   error_message = "Only 1 ipv4_cidrs object can be provided. Lists of CIDRs are passed via the `public` and `private` attributes of the single object."
  # }
}

variable "nat_gateway_enabled" {
  type        = bool
  description = "Flag to enable/disable NAT gateways"
  default     = true
}

variable "nat_instance_enabled" {
  type        = bool
  description = "Flag to enable/disable NAT instances"
  default     = false
}

variable "nat_instance_type" {
  type        = string
  description = "NAT Instance type"
  default     = "t3.micro"
}

variable "subnet_type_tag_key" {
  type        = string
  description = "Key for subnet type tag to provide information about the type of subnets, e.g. `cpco/subnet/type=private` or `cpcp/subnet/type=public`"
}

variable "max_subnet_count" {
  type        = number
  default     = 0
  description = "Sets the maximum amount of subnets to deploy. 0 will deploy a subnet for every provided availability zone (in `region_availability_zones` variable) within the region"
}

variable "vpc_flow_logs_enabled" {
  type        = bool
  description = "Enable or disable the VPC Flow Logs"
  default     = true
}

variable "vpc_flow_logs_traffic_type" {
  type        = string
  description = "The type of traffic to capture. Valid values: `ACCEPT`, `REJECT`, `ALL`"
  default     = "ALL"
}

variable "vpc_flow_logs_log_destination_type" {
  type        = string
  description = "The type of the logging destination. Valid values: `cloud-watch-logs`, `s3`"
  default     = "s3"
}

variable "nat_eip_aws_shield_protection_enabled" {
  type        = bool
  description = "Enable or disable AWS Shield Advanced protection for NAT EIPs. If set to 'true', a subscription to AWS Shield Advanced must exist in this account."
  default     = false
}

variable "eks_tags_enabled" {
  type        = bool
  description = "Whether or not to apply EKS-releated tags to resources"
  default     = false
}

variable "gateway_vpc_endpoints" {
  type        = set(string)
  description = "A list of Gateway VPC Endpoints to provision into the VPC. Only valid values are \"dynamodb\" and \"s3\"."
  default     = []
}

variable "interface_vpc_endpoints" {
  type        = set(string)
  description = "A list of Interface VPC Endpoints to provision into the VPC."
  default     = []
}

variable "public_subnets_enabled" {
  type        = bool
  description = <<-EOT
    If false, do not create public subnets.
    Since NAT gateways and instances must be created in public subnets, these will also not be created when `false`.
    EOT
  default     = true
}

variable "map_public_ip_on_launch" {
  type        = bool
  default     = true
  description = "Instances launched into a public subnet should be assigned a public IP address"
}

variable "private_subnets_enabled" {
  type        = bool
  description = <<-EOT
    If false, do not create public subnets.
    Since NAT gateways and instances must be created in public subnets, these will also not be created when `false`.
    EOT
  default     = true
}

variable "data_subnets_enabled" {
  type        = bool
  description = <<-EOT
    If false, do not create public subnets.
    Since NAT gateways and instances must be created in public subnets, these will also not be created when `false`.
    EOT
  default     = true
}

variable "service_subnets_enabled" {
  type        = bool
  description = <<-EOT
    If false, do not create public subnets.
    Since NAT gateways and instances must be created in public subnets, these will also not be created when `false`.
    EOT
  default     = true
}

variable "inspection_subnets_enabled" {
  type        = bool
  description = <<-EOT
    If false, do not create public subnets.
    Since NAT gateways and instances must be created in public subnets, these will also not be created when `false`.
    EOT
  default     = true
}

variable "gw_subnets_enabled" {
  type        = bool
  description = <<-EOT
    If false, do not create public subnets.
    Since NAT gateways and instances must be created in public subnets, these will also not be created when `false`.
    EOT
  default     = true
}

variable "max_nats" {
  type        = number
  description = <<-EOT
    Upper limit on number of NAT Gateways/Instances to create.
    Set to 1 or 2 for cost savings at the expense of availability.
    EOT
  # Default should be MAX_INT, but Terraform does not provide that. 999 is big enough.
  default = 999
}
