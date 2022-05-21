variable "region" {
  type = string
}

variable "env" {
  type = string
}

variable "vpc_id" {}

variable "private_subnets_ids" {
  type = list(any)
}

variable "public_subnets_ids" {}

variable "github_repo" {
  type = string
}

variable "github_oauth_token" {
  type = string
}

variable "git_trigger_event" {
  default = "PUSH"
}

variable "branch_pattern" {
  default = "main"
}

variable "build_spec_file" {
  default = "buildspec.yml"
}
