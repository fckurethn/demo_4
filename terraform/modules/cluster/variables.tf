variable "region" {
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
