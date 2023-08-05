# specify backend for this configuration
# this is Terraform Cloud based
terraform {
  backend "remote" {
    hostname      = "app.terraform.io"
    organization  = "[YOUR TERRAFORM ORGANIZATION]"

    workspaces {
      name = "respriter-production"
    }
  }
}
