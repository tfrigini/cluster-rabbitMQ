terraform {
  backend "s3" {
      bucket = "terraform-state-rabbit"
      key = "infra/terraform/rabitmq"
      region = "us-east-1"
      profile = "terraform-rabbit"
  }
}