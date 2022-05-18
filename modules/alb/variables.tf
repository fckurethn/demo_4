variable "target_port" {
  default = 80
}

variable "vpc_id" {}

variable "public_subnets_ids" {}

variable "private_subnets_ids" {}

variable "alb_ingress" {
  default = ["80"]
}
