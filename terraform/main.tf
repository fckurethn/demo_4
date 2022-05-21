provider "aws" {
  region = var.region
}

module "vpc" {
  source = "./modules/vpc/"

  env = var.env
  cidr = var.cidr
  private_subnets = var.private_subnets
  public_subnets = var.public_subnets
}

module "alb" {
  source = "./modules/alb"

  env = var.env
  public_subnets_ids  = module.vpc.public_subnets_ids
  private_subnets_ids = module.vpc.private_subnets_ids
  vpc_id              = module.vpc.vpc_id

  depends_on = [module.vpc]
}

module "asg" {
  source = "./modules/asg"

  instance_type = var.instance_type
  env = var.env
  vpc_id              = module.vpc.vpc_id
  target_group_arns   = module.alb.target_group_arns
  private_subnets_ids = module.vpc.private_subnets_ids

  depends_on = [module.vpc]
}

module "cluster" {
  source = "./modules/cluster"

  env = var.env
  region = var.region
  github_repo = var.github_repo
  tf_tg_arn = module.alb.target_group_arns

  depends_on = [module.alb]
}

module "codebuild" {
  source = "./modules/codebuild"

  region = var.region
  env = var.env
  vpc_id = module.vpc.vpc_id
  private_subnets_ids = module.vpc.private_subnets_ids
  public_subnets_ids = module.vpc.public_subnets_ids
  github_repo = var.github_repo
  github_oauth_token = var.github_oauth_token
}
