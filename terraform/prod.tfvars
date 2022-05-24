env           = "prod"
account_id    = "859431955366"
region        = "eu-central-1"
bucket_name   = "mbabych-pepe-prod-eu-central-1"
github_repo   = "https://github.com/fckurethn/demo_4/"
buildspec     = "./terraform/modules/codebuild/buildspec.yml"
app_name      = "pepe-frog"
app_tag       = "v1"
instance_type = "t2.micro"
cidr          = "10.0.0.0/16"
private_subnets = {
  subnet_1 = {
    az   = "eu-central-1a"
    cidr = "10.0.11.0/24"
  }
  subnet_2 = {
    az   = "eu-central-1b"
    cidr = "10.0.22.0/24"
  }
}
public_subnets = {
  subnet_1 = {
    az   = "eu-central-1a"
    cidr = "10.0.1.0/24"
  }
  subnet_2 = {
    az   = "eu-central-1b"
    cidr = "10.0.2.0/24"
  }
}
