variable "app" {
  default = "respriter"
}

variable "prefix" {
  default = "rspt-"
}

variable "origin" {
  default = "terraform"
}

variable "environment" {
  default = "production"
}

variable "aws_region" {
  default = "us-east-1"
}

variable "aws_base_cidr_block" {
  default = "10.0.0.0/20"
}

variable "aws_instance_type" {
  default = "t3a.small"
}

# grab from packer output
variable "aws_ami" {
  default = "respriter-1593465451"
}

# created on the console
variable "aws_key_name" {
  default = "[YOUR AWS SSH KEY NAME]"
}

variable "aws_codepipeline_github_branch" {
  default = "production"
}

# this service file is created during image build
variable "aws_launch_configuration_user_data" {
  default = <<EOF
#!/bin/bash
ln -s /home/ubuntu/respriter.service /lib/systemd/system/respriter.service
sudo systemctl enable respriter
sudo systemctl start respriter
EOF
}

variable "aws_cloudfront_distribution_query_cache_keys" {
  default = [ "providers", "tags", "country-flags", "i18n", "brand", "all", "icons" ]
}

variable "github_organization" {
  default = "[YOUR GITHUB ORGANIZATION]"
}

variable "github_repository" {
  default = "respriter"
}

variable "github_repository_webhook_secret" {
  default = "[GITHUB WEBHOOK SECRET]"
}

variable "cloudflare_zone" {
  default = "your.production.domain.com"
}

variable "cloudflare_subdomain" {
  default = "respriter"
}

variable "cloudflare_paused" {
  default = false
}

variable "certificate_arn" {
  type = map(string)
  default = {
    "your.staging.domain.com" = "arn:aws:acm:us-east-1:452837582654:certificate/5e34a122-9960-4902-5768-8ba26c7f3bd6"
    "your.production.domain.com" = "arn:aws:acm:us-east-1:452837582654:certificate/d5c5b123-8617-3444-85e4-006cfcc20ee6"
 }
}