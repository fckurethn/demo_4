variable "env" {
  type    = string
  default = ""
}

variable "profile" {
  type    = string
  default = ""
}

variable "app_tag" {
  type = string
}

variable "account_id" {
  type = string
}

variable "region" {
  type = string
}

variable "bucket_name" {
  type = string
}

variable "github_oauth_token" {
  type    = string
  default = ""
}

variable "github_repo" {
  type    = string
  default = ""
}

variable "buildspec" {
  type    = string
  default = ""
}

variable "app_name" {
  type    = string
  default = ""
}

variable "instance_type" {
  type    = string
  default = ""
}

variable "cidr" {
  type    = string
  default = ""
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
