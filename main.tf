provider "aws" {
  region = var.region
}

module "vpc" {
  source = "./modules/vpc/"
}

module "alb" {
  source = "./modules/alb"

  public_subnets_ids  = module.vpc.public_subnets_ids
  private_subnets_ids = module.vpc.private_subnets_ids
  vpc_id              = module.vpc.vpc_id

  depends_on = [module.vpc]
}

module "asg" {
  source = "./modules/asg"

  vpc_id              = module.vpc.vpc_id
  target_group_arns   = module.alb.target_group_arns
  public_subnets_ids = module.vpc.public_subnets_ids

  depends_on = [module.vpc]
}

module "cluster" {
  source = "./modules/cluster"

  tf_tg_arn = module.alb.target_group_arns

  depends_on = [module.alb]
}
