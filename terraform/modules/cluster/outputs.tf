output "repository_url" {
  value = aws_ecr_repository.demo.repository_url
}

output "registry_id" {
  value = aws_ecr_repository.demo.registry_id
}

output "task_definition_family" {
  value = aws_ecs_task_definition.demo.family
}

output "task_definition_cluster" {
  value = aws_ecs_cluster.ecs_cluster.name
}

output "task_definition_service" {
  value = aws_ecs_service.demo.name
}

output "target_group_arns" {
  value = aws_alb_target_group.tf_tg.arn
}

output "alb_dns_name" {
  value       = aws_alb.tf_alb.dns_name
  description = "Domain name ALB"
}

output "security_group_id" {
  value = aws_security_group.allowed_ports.id
}
