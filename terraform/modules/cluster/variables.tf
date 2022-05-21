variable "region" {
  type = string
}

variable "env" {
  type = string
}

variable "github_repo" {
  type = string
}

variable "app_tag" {
  default = "v1"
}

variable "tf_tg_arn" {}
