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
/*variable "public_subnets" {
  type        = list(string)
  default     = []
}

variable "private_subnets" {
  type        = list(string)
  default     = []
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
*/
