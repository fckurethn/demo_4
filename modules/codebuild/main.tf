resource "aws_s3_bucket" "demo-pepe-frog" {
  bucket = "demo-pepe-frog"
}

resource "aws_s3_bucket_acl" "demo" {
  bucket = aws_s3_bucket.demo-pepe-frog.id
  acl    = "private"
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

  /*vpc_config {
    vpc_id = aws_vpc.example.id

    subnets = [
      aws_subnet.example1.id,
      aws_subnet.example2.id,
    ]

    security_group_ids = [
      aws_security_group.example1.id,
      aws_security_group.example2.id,
    ]
  }
*/
  tags = {
    Environment = "demo"
  }
}

