variable "region" {
  type = string
}

variable "app_name" {
  type = string
}

variable "env" {
  type = string
}

variable "github_repo" {
  type = string
}

variable "vpc_id" {}

variable "public_subnets_ids" {}

variable "private_subnets_ids" {}

variable "app_tag" {
  default = "v1"
}

variable "target_port" {
  default = 80
}

variable "instance_type" {
  type = string
}

variable "ecs_task_execution_role_name" {
  description = "ECS task execution role name"
  default     = "TaskExecutionRole"
}

variable "ecs_task_role_name" {
  default = "TaskRole"
}
