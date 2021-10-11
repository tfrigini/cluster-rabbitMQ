locals {
  public_dns_zone = {
    development = {
      zone = "rabbit.dev.br"
    },
    homologation = {

    },
    production = {
    }
  }
}

module "public_zone" {
  source = "./modules/route-53"

  route53_zone = local.public_dns_zone[terraform.workspace].zone
}