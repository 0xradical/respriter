############
### EC2 ####
############

# Create a VPC to launch our instances into
resource "aws_vpc" "default" {
  cidr_block = var.aws_base_cidr_block

  tags = {
    App         = var.app
    Environment = var.environment
    Origin      = var.origin
  }
}

# Create an internet gateway to give our subnets
# access to the outside world
resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id

  tags = {
    App         = var.app
    Environment = var.environment
    Origin      = var.origin
  }
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
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  vpc_id                  = aws_vpc.default.id
  cidr_block              = "10.0.${1+count.index}.0/24"
  map_public_ip_on_launch = true

  tags = {
    App         = var.app
    Environment = var.environment
    Origin      = var.origin
    CIDR        = "10.0.${1+count.index}.0/24"
  }
}

# A security group for the ELB
# so it is accessible via the web
resource "aws_security_group" "elb" {
  name_prefix = var.prefix
  description = "ELB SG to allow http(s) connections"
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

  tags = {
    App         = var.app
    Environment = var.environment
    Origin      = var.origin
  }
}

# Our default security group to access
# the instances over SSH and HTTP
resource "aws_security_group" "default" {
  name_prefix = var.prefix
  description = "Default SG to allow http(s)/ssh connections"
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
    from_port   = 8080
    to_port     = 8080
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

  tags = {
    App         = var.app
    Environment = var.environment
    Origin      = var.origin
  }
}

# ELB
resource "aws_elb" "web" {
  name_prefix        = var.prefix
  subnets            = aws_subnet.default.*.id
  security_groups    = [aws_security_group.elb.id]

  # HTTPS is ELB terminated
  listener {
    instance_port      = 8080
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = var.classpert_certificate_arn[var.cloudflare_zone]
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8080/healthcheck"
    interval            = 30
  }

  tags = {
    App         = var.app
    Environment = var.environment
    Origin      = var.origin
  }
}

# role that allows instance itself to run aws code
resource "aws_iam_role" "instance" {
  name = "${var.app}-${var.environment}-instance-role"

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

  tags = {
    App         = var.app
    Environment = var.environment
    Origin      = var.origin
  }
}

# allow instance role to access artifacts in code pipeline bucket
resource "aws_iam_role_policy" "instance_profile_policy" {
  name_prefix = var.prefix
  role        = aws_iam_role.instance.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Action": [
        "s3:GetLifecycleConfiguration",
        "s3:GetBucketTagging",
        "s3:GetInventoryConfiguration",
        "s3:GetObjectVersionTagging",
        "s3:ListBucketVersions",
        "s3:GetBucketLogging",
        "s3:ListBucket",
        "s3:GetAccelerateConfiguration",
        "s3:GetBucketPolicy",
        "s3:GetObjectVersionTorrent",
        "s3:GetObjectAcl",
        "s3:GetEncryptionConfiguration",
        "s3:GetBucketObjectLockConfiguration",
        "s3:GetBucketRequestPayment",
        "s3:GetObjectVersionAcl",
        "s3:GetObjectTagging",
        "s3:GetMetricsConfiguration",
        "s3:GetBucketPublicAccessBlock",
        "s3:GetBucketPolicyStatus",
        "s3:ListBucketMultipartUploads",
        "s3:GetObjectRetention",
        "s3:GetBucketWebsite",
        "s3:GetBucketVersioning",
        "s3:GetBucketAcl",
        "s3:GetObjectLegalHold",
        "s3:GetBucketNotification",
        "s3:GetReplicationConfiguration",
        "s3:ListMultipartUploadParts",
        "s3:GetObject",
        "s3:GetObjectTorrent",
        "s3:GetBucketCORS",
        "s3:GetAnalyticsConfiguration",
        "s3:GetObjectVersionForReplication",
        "s3:GetBucketLocation",
        "s3:GetObjectVersion"
      ],
      "Resource": [
        "${aws_s3_bucket.codepipeline_bucket.arn}",
        "${aws_s3_bucket.codepipeline_bucket.arn}/*"
      ]
    },
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.cache.arn}",
        "${aws_s3_bucket.cache.arn}/*"
      ]
    }
  ]
}
EOF
}

# an instance profile for the autoscaled instance
resource "aws_iam_instance_profile" "respriter_profile" {
  name_prefix = var.prefix
  role        = aws_iam_role.instance.name
}

# launch configuration for the asg
resource "aws_launch_configuration" "default" {
  name_prefix          = var.prefix
  image_id             = data.aws_ami.default.id
  instance_type        = var.aws_instance_type
  security_groups      = [aws_security_group.default.id]
  iam_instance_profile = aws_iam_instance_profile.respriter_profile.name
  key_name             = var.aws_key_name
  user_data            = var.aws_launch_configuration_user_data

  lifecycle {
    create_before_destroy = true
  }
}

# ELB-based asg
resource "aws_autoscaling_group" "default" {
  name_prefix               = var.prefix
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

  tags = [
    {
      key = "App", value = var.app, propagate_at_launch = true
    },
    {
      key = "Environment", value = var.environment, propagate_at_launch = true
    },
    {
      key = "Origin", value = var.origin, propagate_at_launch = true
    }
  ]
}

# asg policy
resource "aws_autoscaling_policy" "default" {
  name                   = "${var.app}-${var.environment}-autoscaling-policy"
  policy_type            = "TargetTrackingScaling"
  adjustment_type        = "ChangeInCapacity"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 60.0
  }
  autoscaling_group_name = aws_autoscaling_group.default.name
}

####################
#### Cloudfront ####
####################


resource "aws_s3_bucket" "cache" {
  bucket_prefix = var.prefix
  acl           = "public-read"

  tags = {
    App         = var.app
    Environment = var.environment
    Origin      = var.origin
    Purpose     = "Cache"
  }
}

resource "aws_iam_role" "cloudfront_lambda" {
  name = "${var.app}-${var.environment}-cf-lambda-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": [
            "lambda.amazonaws.com",
            "edgelambda.amazonaws.com"
          ]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "cloudfront_lambda" {
  name_prefix = var.app
  role        = aws_iam_role.cloudfront_lambda.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "lambda:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:CreateLogGroup"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

# This is to optionally manage the CloudWatch Log Group for the Lambda Function.
# If skipping this resource configuration, also add "logs:CreateLogGroup" to the IAM policy below.
resource "aws_cloudwatch_log_group" "s3_origin_request" {
  name              = "/aws/lambda/${var.aws_region}.${aws_lambda_function.s3_origin_request.function_name}"
  retention_in_days = 5

  depends_on = [aws_iam_role_policy.cloudfront_lambda]
}

resource "aws_lambda_function" "s3_origin_request" {
  filename         = data.archive_file.origin_request_lambda_zip.output_path
  function_name    = "origin_request"
  role             = aws_iam_role.cloudfront_lambda.arn
  handler          = "origin_request.handler"
  source_code_hash = data.archive_file.origin_request_lambda_zip.output_base64sha256
  runtime          = "nodejs12.x"
  publish          = true

  tags = {
    App         = var.app
    Environment = var.environment
    Origin      = var.origin
  }
}

resource "aws_lambda_permission" "allow_cloudfront_request_lambda_call" {
  statement_id_prefix = var.app
  action              = "lambda:GetFunction"
  function_name       = aws_lambda_function.s3_origin_request.function_name
  principal           = "cloudfront.amazonaws.com"
}

# Cloudfront distribution with failover
resource "aws_cloudfront_distribution" "default" {
  enabled = true
  aliases = ["${var.cloudflare_subdomain}.${var.cloudflare_zone}"]
  comment = "@${var.origin} @${var.app} @${var.environment}"

  viewer_certificate {
    acm_certificate_arn = var.classpert_certificate_arn[var.cloudflare_zone]
    ssl_support_method = "sni-only"
    minimum_protocol_version = "TLSv1.1_2016"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  origin_group {
    origin_id = "${var.app}-${var.environment}-cloudfront-group"

    failover_criteria {
      status_codes = [403, 404, 500, 502]
    }

    member {
      origin_id = "${var.app}-${var.environment}-cloudfront-group-member-primary"
    }

    member {
      origin_id = "${var.app}-${var.environment}-cloudfront-group-member-failover"
    }
  }

  origin {
    domain_name = aws_s3_bucket.cache.bucket_domain_name
    origin_id   = "${var.app}-${var.environment}-cloudfront-group-member-primary"
    origin_path = ""

    s3_origin_config {
      origin_access_identity = ""
    }
  }

  origin {
    domain_name = aws_elb.web.dns_name
    origin_id   = "${var.app}-${var.environment}-cloudfront-group-member-failover"

    custom_origin_config {
      http_port = 80
      https_port = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols = ["TLSv1.1"]
    }

    custom_header {
      name = "X-Cache-Bucket-Name"
      value = aws_s3_bucket.cache.id
    }
  }

  default_cache_behavior {
    target_origin_id = "${var.app}-${var.environment}-cloudfront-group"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    viewer_protocol_policy = "redirect-to-https"
    compress               = true

    forwarded_values {
      query_string = true
      query_string_cache_keys = var.aws_cloudfront_distribution_query_cache_keys

      cookies {
        forward = "none"
      }

      headers = ["Host"]
    }

    lambda_function_association {
      event_type   = "origin-request"
      lambda_arn   = aws_lambda_function.s3_origin_request.qualified_arn
      include_body = false
    }
  }

  tags = {
    App         = var.app
    Environment = var.environment
    Origin      = var.origin
  }

  depends_on = [
    aws_lambda_permission.allow_cloudfront_request_lambda_call
  ]
}

#####################
#### Code Deploy ####
#####################

# code deploy app
resource "aws_codedeploy_app" "default" {
  name = var.app
}

# sns topic that will be used
# to send deployment events
resource "aws_sns_topic" "deploy" {
  name_prefix = var.prefix
}

# role that allows code deploy to run
resource "aws_iam_role" "deploy" {
  name = "${var.app}-${var.environment}-code-deploy-role"

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
          "codedeploy.us-east-1.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  tags = {
    App         = var.app
    Environment = var.environment
    Origin      = var.origin
  }
}

# minimal service role policies for code deploy role
resource "aws_iam_role_policy_attachment" "AWSCodeDeployRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
  role       = aws_iam_role.deploy.name
}

# code deploy deployment group
# containing ec2 asg
resource "aws_codedeploy_deployment_group" "deployment_group" {
  app_name               = aws_codedeploy_app.default.name
  autoscaling_groups     = [aws_autoscaling_group.default.name]
  deployment_config_name = "CodeDeployDefault.OneAtATime"
  deployment_group_name  = "${var.app}-${var.environment}-deployment-group"
  service_role_arn       = aws_iam_role.deploy.arn

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "IN_PLACE"
  }

  load_balancer_info {
    elb_info {
      name = aws_elb.web.name
    }
  }

  trigger_configuration {
    trigger_events     = [
      "DeploymentStart",
      "DeploymentSuccess",
      "DeploymentFailure",
      "DeploymentStop",
      "DeploymentRollback",
      "InstanceStart",
      "InstanceSuccess",
      "InstanceFailure"
    ]
    trigger_name       = "${var.app}-${var.environment}-deployment-event"
    trigger_target_arn = aws_sns_topic.deploy.arn
  }
}


#######################
#### Code Pipeline ####
#######################

# bucket to store code pipeline artifacts (github clone)
resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket_prefix = var.prefix
  acl           = "private"

  lifecycle_rule {
    id      = "code"
    enabled = true

    expiration {
      days = 1
    }
  }

  tags = {
    App         = var.app
    Environment = var.environment
    Origin      = var.origin
  }
}

# role that allows code pipeline service to run
resource "aws_iam_role" "codepipeline_role" {
  name_prefix = var.prefix

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  tags = {
    App         = var.app
    Environment = var.environment
    Origin      = var.origin
  }
}


# allow code pipeline role to store artifacts in bucket
resource "aws_iam_role_policy" "codepipeline_policy" {
  name_prefix = var.prefix
  role        = aws_iam_role.codepipeline_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "${aws_s3_bucket.codepipeline_bucket.arn}",
        "${aws_s3_bucket.codepipeline_bucket.arn}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "codedeploy:*"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

# code pipeline that will trigger code deploy
resource "aws_codepipeline" "codepipeline" {
  name     = "${var.app}-${var.environment}-codepipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    # GITHUB_TOKEN in env var
    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = [var.github_repository]

      configuration = {
        Owner  = var.github_organization
        Repo   = var.github_repository
        Branch = var.aws_codepipeline_github_branch
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeploy"
      input_artifacts = [var.github_repository]
      version         = "1"

      configuration = {
        ApplicationName     = aws_codedeploy_app.default.name,
        DeploymentGroupName = aws_codedeploy_deployment_group.deployment_group.deployment_group_name
      }
    }
  }

  tags = {
    App         = var.app
    Environment = var.environment
    Origin      = var.origin
  }
}

resource "aws_codepipeline_webhook" "respriter" {
  name            = "${var.app}-${var.environment}-webhook-from-github"
  authentication  = "GITHUB_HMAC"
  target_action   = "Source"
  target_pipeline = aws_codepipeline.codepipeline.name

  authentication_configuration {
    secret_token = var.github_repository_webhook_secret
  }

  filter {
    json_path    = "$.ref"
    match_equals = "refs/heads/${var.aws_codepipeline_github_branch}"
  }

  tags = {
    App         = var.app
    Environment = var.environment
    Origin      = var.origin
  }
}

################
#### Github ####
################

# user associated with GITHUB_TOKEN should also
# be added as an ADMIN at the project
resource "github_repository_webhook" "default" {
  repository = data.github_repository.default.name

  configuration {
    url          = aws_codepipeline_webhook.respriter.url
    content_type = "json"
    insecure_ssl = false
    secret       = var.github_repository_webhook_secret
  }

  active = true
  events = ["create"]
}

####################
#### Cloudflare ####
####################

# create entry for cloudfront on cloudflare
resource "cloudflare_record" "default" {
  zone_id = data.cloudflare_zones.default.zones[0].id
  name    = var.cloudflare_subdomain
  value   = aws_cloudfront_distribution.default.domain_name
  type    = "CNAME"
  proxied = true
}
