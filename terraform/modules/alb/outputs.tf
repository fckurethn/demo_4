output "target_group_arns" {
  value = aws_alb_target_group.tf_tg.arn
}

output "alb_dns_name" {
  value       = aws_alb.tf_alb.dns_name
  description = "Domain name ALB"
}
