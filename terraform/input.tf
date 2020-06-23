# All available AZ to create subnets
data "aws_availability_zones" "available" {
  filter {
    name   = "zone-name"
    values = ["us-east-1a", "us-east-1b"]
  }
}

data "aws_ami" "default" {
  most_recent = true
  name_regex  = "^${var.aws_ami}"
  owners      = ["self"]

  filter {
    name   = "name"
    values = [var.aws_ami]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Bucket used in cloudfront failover
data "aws_s3_bucket" "cloudfront_failover" {
  bucket = var.aws_cloudfront_distribution_failover_bucket
}

# Add cloudflare entry to cloudfront
data "cloudflare_zones" "default" {
  filter {
    name   = var.cloudflare_zone
    status = "active"
    paused = false
  }
}

# Fetch respriter project from GH
data "github_repository" "default" {
  full_name = "${var.github_organization}/${var.github_repository}"
}