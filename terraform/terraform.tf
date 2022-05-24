/*provider "aws" {
  region  = var.region
  profile = var.account_id
}*/

terraform {
  backend "s3" {
    encrypt = true
    bucket  = "mbabych-pepe-prod-eu-central-1"
    #    bucket  = "mbabych-pepe-dev-eu-central-1"
    region         = "eu-central-1"
    key            = "terraform.tfstate"
    dynamodb_table = "terraform_state_eu_central_1"
  }

  /*  required_providers {
    aws = {
      version = "~> 3.35"
    }
  }*/
}
