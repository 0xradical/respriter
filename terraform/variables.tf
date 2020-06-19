variable "version" {
  default = "~> 2.66"
}

variable "region" {
  default = "us-east-1"
}

variable "base_cidr_block" {
  default = "10.0.0.0/20"
}

variable "instance_type" {
  default = "t3a.small"
}

# # Ubuntu Precise 12.04 LTS (x64)
# get region from data sources ?
variable "amis" {
  type = "map"
  default = {
    us-east-1 = "ami-1d4e7a66"
    us-west-1 = "ami-969ab1f6"
    us-west-2 = "ami-8803e0f0"
  }
}
