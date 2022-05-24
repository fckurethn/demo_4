resource "aws_alb" "tf_alb" {
  name               = "${var.env}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = aws_subnet.public.*.id

  tags = {
    Name = "${var.env}-ALB"
  }
}

resource "aws_alb_target_group" "tf_tg" {
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.tf_vpc.id

  health_check {
    healthy_threshold   = "3"
    interval            = "10"
    protocol            = "HTTP"
    matcher             = "200"
    unhealthy_threshold = "2"
  }
}

resource "aws_alb_listener" "demo" {
  load_balancer_arn = aws_alb.tf_alb.arn
  port              = var.target_port
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "404"
      status_code  = 404
    }
  }
}

resource "aws_alb_listener_rule" "asg-listener_rule" {
  listener_arn = aws_alb_listener.demo.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.tf_tg.arn
  }
}

resource "aws_security_group" "alb" {
  vpc_id = aws_vpc.tf_vpc.id
  name   = "alb security group"

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

  tags = {
    Name = "${var.env} ALB security group "
  }
}
