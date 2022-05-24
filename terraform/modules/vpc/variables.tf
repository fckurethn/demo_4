variable "region" {
  type = string
}

variable "env" {
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
