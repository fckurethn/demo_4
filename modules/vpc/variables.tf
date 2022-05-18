variable "cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  type = map(any)
  default = {
    subnet_1 = {
      az   = "eu-central-1a"
      cidr = "10.0.1.0/24"
    }
    subnet_2 = {
      az   = "eu-central-1b"
      cidr = "10.0.2.0/24"
    }
  }
}

variable "private_subnets" {
  type = map(any)
  default = {
    subnet_1 = {
      az   = "eu-central-1a"
      cidr = "10.0.11.0/24"
    }
    subnet_2 = {
      az   = "eu-central-1b"
      cidr = "10.0.22.0/24"
    }
  }
}

variable "environment" {
  default = "demo"
}
