provider "archive" {
  version = "~> 1.3.0"
}

provider "aws" {
  version = "~> 2.67.0"
  region  = var.aws_region
}

provider "github" {
  version = "~> 2.8.1"
  individual = false
  organization = "[YOUR GITHUB ORGANIZATION]"
}

provider "cloudflare" {
  version = "~> 2.8.0"
}
