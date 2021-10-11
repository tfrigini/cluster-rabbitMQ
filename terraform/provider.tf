provider "aws" {
  region = "eu-central-1"
  profile = "terraform-rabbit"
  # assume_role {
  #   role_arn = var.workspace_iam_roles[terraform.workspace]
  # }
  
  default_tags {
    tags = {
      "ManagedBy"   = "terraform",
      "Environment" = terraform.workspace
    }
  }
}