#Obtém zonas de disponibilidade da região
data "aws_availability_zones" "available" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.7.0"

  name                          = var.vpc_configs["name"]
  cidr                          = var.vpc_configs["CIDR"]
  azs                           = length(var.vpc_configs["azs"]) > 0 ? var.vpc_configs["azs"] : data.aws_availability_zones.available.names
  private_subnets               = var.vpc_configs["private_subnets"]
  public_subnets                = var.vpc_configs["public_subnets"]
  database_subnets              = var.vpc_configs["database_subnets"]

  enable_nat_gateway            = true
  single_nat_gateway            = true
  enable_dns_hostnames          = true
  create_database_subnet_group  = true
  enable_vpn_gateway            = var.vpc_configs["enable_vpn_gateway"]
  amazon_side_asn               = var.vpc_configs["aws_asn"]

  # Incluir de forma dinâmica
  customer_gateways = var.customer_gateways

  tags = {
    "module" = "network"
  }

  public_subnet_tags = merge(var.public_subnet_tags)

  private_subnet_tags = merge(var.private_subnet_tags)
}