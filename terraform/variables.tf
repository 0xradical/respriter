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

# # Ubuntu Bionic 18.04 LTS (x64)
# https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/virtualization_types.html
# HVM Instance Store
variable "aws_amis" {
  type = map(string)
  default = {
    us-east-1 	    = "ami-0938f2289b3fa3f5b"
    us-east-2 	    = "ami-07dfef221b460a96d"
    us-west-1 	    = "ami-08459fd7d3a81b9fa"
    us-west-2 	    = "ami-006e5c0a12065c81b"
    ca-central-1 	  = "ami-0866476a35d455a04"
    sa-east-1 	    = "ami-07c06b646d313101b"
    ap-northeast-1 	= "ami-07811955ea19a7cf1"
    ap-northeast-2 	= "ami-0977be68ecf0a04a6"
    ap-northeast-3 	= "ami-0165a1f39ee7ad881"
    ap-south-1 	    = "ami-0875b5c58086ec1df"
    ap-southeast-1 	= "ami-086087c673aa5987f"
    ap-southeast-2 	= "ami-0839d8742359e8348"
    eu-north-1 	    = "ami-00a9eaf83fa3c440e"
    eu-west-1 	    = "ami-00c94f76a6b635ccd"
    eu-west-2 	    = "ami-075d6aa2563bfbbc8"
    eu-west-3 	    = "ami-0fdab4d058f7b1496"
    eu-central-1 	  = "ami-01f009950b026d11f"
  }
}

variable "aws_code_deploy_resource_kits" {
  type = map(string)
  default = {
    us-east-2      = "aws-codedeploy-us-east-2"
    us-east-1      = "aws-codedeploy-us-east-1"
    us-west-1      = "aws-codedeploy-us-west-1"
    us-west-2      = "aws-codedeploy-us-west-2"
    ca-central-1   = "aws-codedeploy-ca-central-1"
    eu-west-1      = "aws-codedeploy-eu-west-1"
    eu-west-2      = "aws-codedeploy-eu-west-2"
    eu-west-3      = "aws-codedeploy-eu-west-3"
    eu-central-1   = "aws-codedeploy-eu-central-1"
    ap-east-1      = "aws-codedeploy-ap-east-1"
    ap-northeast-1 = "aws-codedeploy-ap-northeast-1"
    ap-northeast-2 = "aws-codedeploy-ap-northeast-2"
    ap-southeast-1 = "aws-codedeploy-ap-southeast-1"
    ap-southeast-2 = "aws-codedeploy-ap-southeast-2"
    ap-south-1     = "aws-codedeploy-ap-south-1"
    sa-east-1      = "aws-codedeploy-sa-east-1"
  }
}















