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
  name          = "${var.env}-pepe"
  description   = "test_codebuild_project"
  build_timeout = "5"
  service_role  = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  cache {
    type     = "S3"
    location = aws_s3_bucket.demo-pepe-frog.bucket
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:4.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true

    environment_variable {
      name  = "ENV"
      value = var.env
    }
    environment_variable {
      name  = "AWS_REGION"
      value = var.region
    }
    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = var.account_id
    }
    environment_variable {
      name  = "ECR_APP_URL"
      value = var.repository_url
    }
    environment_variable {
      name  = "TASK_DEFINITION_FAMILY"
      value = var.task_definition_family
    }
    environment_variable {
      name  = "TASK_DEFINITION_CLUSTER"
      value = var.task_definition_cluster
    }
    environment_variable {
      name  = "TASK_DEFINITION_SERVICE"
      value = var.task_definition_service
    }
  }
  source {
    type                = "GITHUB"
    location            = var.github_repo
    git_clone_depth     = 1
    report_build_status = "true"
    buildspec           = var.buildspec

  }

  vpc_config {
    vpc_id = var.vpc_id

    subnets = var.private_subnets_ids

    security_group_ids = [aws_security_group.codebuild_sg.id]
  }

  tags = {
    Environment = "${var.env}"
  }
}

resource "aws_codebuild_webhook" "demo_webhook" {
  project_name = aws_codebuild_project.demo-pepe.name

  filter_group {
    filter {
      type    = "EVENT"
      pattern = var.git_trigger_event
    }

    filter {
      type    = "HEAD_REF"
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
