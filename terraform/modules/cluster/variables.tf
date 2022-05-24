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

variable "target_port" {
  default = 80
}

variable "instance_type" {
  type = string
}

variable "cidr" {
  type = string
}

variable "public_subnets" {
  type = map(object({
    az   = string
    cidr = string
  }))
}
variable "private_subnets" {
  type = map(object({
    az   = string
    cidr = string
  }))
}
