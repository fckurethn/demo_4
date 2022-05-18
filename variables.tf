variable "region" {
  type    = string
  default = "eu-central-1"
}

variable "tags" {
  default = {
    Owner   = "Mykhailo Babych"
    Project = "Third Demo"
  }
}
