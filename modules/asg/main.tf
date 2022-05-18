resource "aws_autoscaling_group" "demo_asg" {
  desired_capacity    = 2
  max_size            = 2
  min_size            = 2
  target_group_arns   = [var.target_group_arns]
  vpc_zone_identifier = var.public_subnets_ids
  launch_template {
    id      = aws_launch_template.demo_asg.id
    version = "$Latest"
  }
}

data "aws_ami" "amazon_linux" {
  owners      = ["591542846629"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }
}

resource "aws_launch_template" "demo_asg" {
  name = "DemoASG"

  vpc_security_group_ids               = [aws_security_group.allowed_ports.id]
  image_id                             = data.aws_ami.amazon_linux.id
  instance_initiated_shutdown_behavior = "terminate"
  instance_type                        = var.instance_type
  key_name                             = "aws-main"
  user_data                            = filebase64("./modules/asg/user_data.sh")

  iam_instance_profile {
    name = aws_iam_instance_profile.ecs_agent.name
  }
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "Demo instance"
    }
  }
}

resource "aws_security_group" "allowed_ports" {
  name        = "allowed ports"
  description = "ports that needed for work"
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
