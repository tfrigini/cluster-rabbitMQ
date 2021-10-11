variable "vpc_configs" {
  description = "Configs of the VPC to create"
  type        = object({
    name                = string,
    CIDR                = string,
    private_subnets     = list(string),
    public_subnets      = list(string),
    database_subnets    = list(string),
    enable_vpn_gateway  = bool,
    azs                 = list(string),
    aws_asn             = number
  })
}

variable "public_subnet_tags" {
  description = "Tags for public subnets"
  type        = map(string)
  default     = null
}

variable "private_subnet_tags" {
  description = "Tags for public subnets"
  type        = map(string)
  default     = null
}

variable "customer_gateways" {
  type        = map(map(any))
  description = "Maps of Customer Gateway's attributes (BGP ASN and Gateway's Internet-routable external IP address)"
  default     = {}
}