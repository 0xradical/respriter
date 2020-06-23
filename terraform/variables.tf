variable "classpert_certificate_arn" {}

variable "github_personal_access_token" {}

variable "aws_region" {
  default = "us-east-1"
}

variable "aws_base_cidr_block" {
  default = "10.0.0.0/20"
}

variable "aws_instance_type" {
  default = "t3a.small"
}

variable "respriter_ami" {
  default = "respriter-1592875989"
}

# created on the console
variable "key_name" {
  default = "thiago"
}

variable "webhook_secret" {
  default = "a94dc512ef22af15644f95fc8a78d989"
}












