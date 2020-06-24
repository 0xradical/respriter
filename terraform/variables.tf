variable "app" {
  default = "respriter"
}

variable "prefix" {
  default = "rpst"
}

variable "origin" {
  default = "terraform"
}

variable "environment" {
  default = "staging"
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
  default = "respriter-1593015563"
}

# created on the console
variable "aws_key_name" {
  default = "thiago"
}

variable "aws_codepipeline_github_branch" {
  default = "staging"
}

# this service file is created during image build
variable "aws_launch_configuration_user_data" {
  default = <<EOF
!#/bin/bash
ln -s /home/ubuntu/respriter.service /lib/systemd/system/respriter.service
EOF
}

variable "aws_cloudfront_distribution_failover_bucket" {
  default = "clspt-elements-dist-prd"
}

variable "aws_cloudfront_distribution_failover_path" {
  default = "/svgs/tags.svg"
}

variable "aws_cloudfront_distribution_query_cache_keys" {
  default = [ "providers", "tags", "country-flags", "i18n", "brand" ]
}

variable "github_organization" {
  default = "classpert"
}

variable "github_repository" {
  default = "respriter"
}

variable "github_repository_webhook_secret" {
  default = "a94dc512ef22af15644f95fc8a78d989"
}

variable "cloudflare_zone" {
  default = "classpert-staging.com"
}

variable "cloudflare_subdomain" {
  default = "respriter"
}

variable "classpert_certificate_arn" {
  type = map(string)
  default = {
    "classpert-staging.com" = "arn:aws:acm:us-east-1:452887582654:certificate/5e34a122-9960-4902-baab-8ba26c7f3bd6"
    "classpert.com" = "arn:aws:acm:us-east-1:452887582654:certificate/d5c5b123-8617-4dd8-85e4-006cfcc20ee6"
  }
}












