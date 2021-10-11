module "vpc" {
  source            = "./modules/vpc"
  vpc_configs       = var.VPC
  customer_gateways = var.customer_gateways
}
