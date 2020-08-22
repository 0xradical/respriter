# specify backend for this configuration
# this is Terraform Cloud based
terraform {
  backend "remote" {
    hostname      = "app.terraform.io"
    organization  = "classpert"

    workspaces {
      name = "respriter-production"
    }
  }
}
