variable "public_subnets_ids" {}

variable "instance_type" {
  default = "t2.micro"
}

variable "target_group_arns" {}

variable "vpc_id" {}
