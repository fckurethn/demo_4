provider "aws" {
  region = var.region
}

module "cluster" {
  source = "./modules/cluster"

  env             = var.env
  region          = var.region
  cidr            = var.cidr
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
  instance_type   = var.instance_type
  github_repo     = var.github_repo

  depends_on = [module.vpc]
}

module "init-build" {
  source         = "./modules/init-build"
  account_id     = var.account_id
  region         = var.region
  github_repo    = var.github_repo
  app_tag        = var.app_tag
  env            = var.env
  registry_id    = module.cluster.registry_id
  repository_url = module.cluster.repository_url

  depends_on = [module.cluster]
}

module "codebuild" {
  source = "./modules/codebuild"

  account_id              = var.account_id
  region                  = var.region
  env                     = var.env
  vpc_id                  = module.vpc.vpc_id
  private_subnets_ids     = module.vpc.private_subnets_ids
  public_subnets_ids      = module.vpc.public_subnets_ids
  repository_url          = module.cluster.repository_url
  github_repo             = var.github_repo
  github_oauth_token      = var.github_oauth_token
  buildspec               = var.buildspec
  task_definition_family  = module.cluster.task_definition_family
  task_definition_cluster = module.cluster.task_definition_cluster
  task_definition_service = module.cluster.task_definition_service

  depends_on = [module.vpc, module.cluster, module.init-build]
}
