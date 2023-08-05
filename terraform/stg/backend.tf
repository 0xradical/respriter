# specify backend for this configuration
# this is Terraform Cloud based
terraform {
  backend "remote" {
    hostname      = "app.terraform.io"
    organization  = "[YOUR TERRAFORM CLOUD ORGANIZATION]"

    workspaces {
      name = "respriter-staging"
    }
  }
}
