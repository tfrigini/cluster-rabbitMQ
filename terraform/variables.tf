variable "workspace_iam_roles" {
  default = {
    development  = "arn:aws:iam::123456789012:role/Terraform"
    homologation = "arn:aws:iam::123456789013:role/Terraform"
    production   = "arn:aws:iam::123456789014:role/Terraform"
  }
}

variable "VPC_NOW" {
  description = "VPC to create"
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

variable "customer_gateways" {
  type        = map(map(any))
  description = "Maps of Customer Gateway's attributes (BGP ASN and Gateway's Internet-routable external IP address)"
  default     = {}
}

# variable "internal_zone" {
#   description = "Private zone to define resources names"
#   type        = string
# }