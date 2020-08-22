provider "aws" {
  version = "~> 2.66"
  region  = var.aws_region
}

provider "github" {
  version = "~> 2.8"
}

provider "cloudflare" {
  version = "~> 2.0"
}
