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

# Specify the provider and access details
provider "aws" {
  version = "~> 2.66"
  region  = var.aws_region
}

provider "github" {
  version = "~> 2.8"
}

# All available AZ to create subnets
data "aws_availability_zones" "available" {
  filter {
    name   = "zone-name"
    values = ["us-east-1a", "us-east-1b"]
  }
}

# Fetch elements project from GH
data "github_repository" "elements" {
  full_name = "classpert/elements"
}

resource "github_repository_webhook" "elements_webhook" {
  repository = data.github_repository.elements.name

  configuration {
    # endpoint for aws code deploy
    url          = "https://google.de/"
    content_type = "json"
    insecure_ssl = false
  }

  active = true

  events = ["create"]

  # depends_on = ["aws_code_deploy"]
}


# Create a VPC to launch our instances into
resource "aws_vpc" "default" {
  cidr_block = var.aws_base_cidr_block
}

# Create an internet gateway to give our subnets
# access to the outside world
resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id
}

# Grant the VPC internet access on its main route table
resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.default.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.default.id
}

# Create subnets to launch our instances into
# in each AZ (10.0.1.0/24, 10.0.2.0/24, etc)
resource "aws_subnet" "default" {
  count                   = length(data.aws_availability_zones.available.names)
  vpc_id                  = aws_vpc.default.id
  cidr_block              = "10.0.${1+count.index}.0/24"
  map_public_ip_on_launch = true
}

# A security group for the ELB
# so it is accessible via the web
resource "aws_security_group" "elb" {
  name        = "respriter-elb-sg"
  description = "ELB SG to allow http connections"
  vpc_id      = aws_vpc.default.id

  # HTTP access from anywhere
  # Route to HTTPS
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS access from anywhere
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Our default security group to access
# the instances over SSH and HTTP
resource "aws_security_group" "default" {
  name        = "respriter-sg"
  description = "Used in the terraform"
  vpc_id      = aws_vpc.default.id

  # SSH access from anywhere
  # Remove this
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from the VPC
  # Coming from the ELB
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.aws_base_cidr_block]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_elb" "web" {
  name               = "respriter-elb"
  availability_zones = data.aws_availability_zones.available.names
  subnets            = aws_subnet.default.*.id
  security_groups    = [aws_security_group.elb.id]

  # HTTPS is ELB terminated
  listener {
    instance_port      = 80
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = var.classpert_certificate_arn
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }
}

# Inject these via TF_ vars
# resource "aws_key_pair" "auth" {
#   key_name   = "${var.key_name}"
#   public_key = "${file(var.public_key_path)}"
# }

resource "aws_codedeploy_app" "respriter" {
  name = "respriter"
}

resource "aws_iam_role" "deploy" {
  name = "respriter-code-deploy-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "codedeploy.us-east-2.amazonaws.com",
          "codedeploy.us-east-1.amazonaws.com",
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "AWSCodeDeployRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
  role       = aws_iam_role.deploy.name
}

resource "aws_iam_role" "instance" {
  name = "respriter-instance-role"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_iam_instance_profile" "respriter_profile" {
  name = "respriter-profile"
  role = aws_iam_role.instance.name
}

resource "aws_launch_configuration" "default" {
  name_prefix     = "respriter-instance-"
  image_id        = lookup(var.aws_amis, var.aws_region)
  instance_type   = var.aws_instance_type
  security_groups = [aws_security_group.default.id]
  iam_instance_profile = aws_iam_instance_profile.respriter_profile.name
  # key_name        = aws_key_pair.auth.id

  user_data         = <<EOF
!#/bin/bash
echo "export AWS_CODE_DEPLOY_RESOURCE_KIT=https://${lookup(var.aws_code_deploy_resource_kits, var.aws_region)}.s3.${var.aws_region}.amazonaws.com/latest/install" >> config.sh
echo "export GITHUB_PERSONAL_ACCESS_TOKEN=${var.github_personal_access_token}" >> config.sh
EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "default" {
  name                      = "respriter-autoscaling-group"
  min_size                  = 2
  max_size                  = 5
  health_check_type         = "ELB"
  health_check_grace_period = 300
  launch_configuration      = aws_launch_configuration.default.name
  vpc_zone_identifier       = aws_subnet.default.*.id
  load_balancers            = [aws_elb.web.name]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_policy" "default" {
  name                   = "respriter-autoscaling-policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 60.0
  }
  autoscaling_group_name = aws_autoscaling_group.default.name
}

data "aws_s3_bucket" "elements" {
  bucket = "clspt-elements-dist-prd"
}

resource "aws_cloudfront_distribution" "default" {
  enabled = true
  aliases = ["respriter.classpert.com"]
  comment = "Created via Terraform"
  tags = {
    Environment = "production"
  }
  viewer_certificate {
    acm_certificate_arn = var.classpert_certificate_arn
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  origin_group {
    origin_id = "cloudfront-group-respriter"

    failover_criteria {
      status_codes = [403, 404, 500, 502]
    }

    member {
      origin_id = "cloudfront-group-member-primary"
    }

    member {
      origin_id = "cloudfront-group-member-failover"
    }
  }

  origin {
    domain_name = aws_elb.web.dns_name
    origin_id   = "cloudfront-group-member-primary"
  }

  origin {
    domain_name = data.aws_s3_bucket.elements.bucket_regional_domain_name
    origin_id   = "cloudfront-group-member-failover"
    origin_path = "/svgs/tags.svg"
  }

  default_cache_behavior {
    target_origin_id = "cloudfront-group-respriter"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    viewer_protocol_policy = "redirect-to-https"
    compress               = true

    forwarded_values {
      query_string = true
      query_string_cache_keys = [
        "providers",
        "tags",
        "country-flags",
        "i18n",
        "brand"
      ]

      cookies {
        forward = "none"
      }
    }
  }
}

