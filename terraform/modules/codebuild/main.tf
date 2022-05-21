/*terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.35"
    }
  }
}

provider "aws" {
  region  = var.region
#  profile = var.aws_profile
}

*/

resource "null_resource" "import_source_credentials" {


  triggers = {
    github_oauth_token = var.github_oauth_token
  }

  provisioner "local-exec" {
    command = <<EOF
      aws --region ${var.region} codebuild import-source-credentials \
                                                             --token ${var.github_oauth_token} \
                                                             --server-type GITHUB \
                                                             --auth-type PERSONAL_ACCESS_TOKEN
EOF
  }
}

resource "aws_s3_bucket" "demo-pepe-frog" {
  bucket = "demo-pepe-frog"
}

resource "aws_s3_bucket_acl" "demo" {
  bucket = aws_s3_bucket.demo-pepe-frog.id
  acl    = "private"
}

resource "aws_codebuild_source_credential" "this" {
  auth_type   = "PERSONAL_ACCESS_TOKEN"
  server_type = "GITHUB"
  token       = var.github_oauth_token
}

resource "aws_codebuild_project" "demo-pepe" {
  name          = "demo-pepe"
  description   = "test_codebuild_project"
  build_timeout = "5"
  service_role  = aws_iam_role.pepe-demo.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  cache {
    type     = "S3"
    location = aws_s3_bucket.demo-pepe-frog.bucket
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:4.0"
    type                        = "LINUX_CONTAINER"
    privileged_mode = true
/*

  logs_config {
    cloudwatch_logs {
      group_name  = "log-group"
      stream_name = "log-stream"
    }

    s3_logs {
      status   = "ENABLED"
      location = "${aws_s3_bucket.demo-pepe-frog.id}/build-log"
    }
  }
*/
}

  source {
    type            = "GITHUB"
    location        = var.github_repo
    git_clone_depth = 1
    report_build_status = "true"
    buildspec = var.build_spec_file

  }

  vpc_config {
  vpc_id = var.vpc_id

    subnets = var.private_subnets_ids

    security_group_ids = [ aws_security_group.codebuild_sg.id ]
  }

  tags = {
    Environment = "${var.env}"
  }
}

resource "aws_codebuild_webhook" "demo_webhook" {
  project_name = aws_codebuild_project.demo-pepe.name

  filter_group {
    filter {
      type = "EVENT"
      pattern = var.git_trigger_event
    }

    filter {
      type = "HEAD_REF"
      pattern = var.branch_pattern
    }
  }
}

resource "aws_security_group" "codebuild_sg" {
  name        = "allow_vpc_connectivity"
  description = "Allow Codebuild connectivity to all the resources within our VPC"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
