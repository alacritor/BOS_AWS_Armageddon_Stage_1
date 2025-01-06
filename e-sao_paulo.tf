provider "aws" {
  alias  = "sao_paulo"
  region = var.sao_paulo_config.region
}

module "sao_paulo_network" {
  source = "./modules/network"

  region              = var.sao_paulo_config.region
  name                = var.sao_paulo_config.name
  vpc_cidr            = var.sao_paulo_config.vpc_cidr
  public_subnet_cidr  = var.sao_paulo_config.public_subnet_cidr
  private_subnet_cidr = var.sao_paulo_config.private_subnet_cidr
  tgw_id              = module.sao_paulo_tgw_branch.tgw_id
}

module "sao_paulo_frontend" {
  source = "./modules/frontend"

  region            = var.sao_paulo_config.region
  name              = var.sao_paulo_config.name
  vpc_id            = module.sao_paulo_network.vpc_id
  public_subnet_ids = module.sao_paulo_network.public_subnet_ids
  target_group_arn  = module.sao_paulo_backend.target_group_arn
}

module "sao_paulo_backend" {
  source = "./modules/backend"

  region                = var.sao_paulo_config.region
  name                  = var.sao_paulo_config.name
  vpc_id                = module.sao_paulo_network.vpc_id
  private_subnet_ids    = module.sao_paulo_network.private_subnet_ids
  frontend_sg_id        = module.sao_paulo_frontend.frontend_sg_id
  backend_instance_type = var.backend_config.backend_instance_type[1] #Using T.3 Micro for Sao Paulo due to geographical hardware limitations
  desired_capacity      = var.backend_config.desired_capacity
  scaling_range         = var.backend_config.scaling_range
  user_data             = var.backend_config.user_data
}

module "sao_paulo_tgw_branch" {
  source = "./modules/tgw_branch"

  providers = {
    aws.default = aws.sao_paulo
    aws.tokyo   = aws.tokyo
  }

  region             = var.sao_paulo_config.region
  name               = var.sao_paulo_config.name
  vpc_id             = module.sao_paulo_network.vpc_id
  private_subnet_ids = module.sao_paulo_network.private_subnet_ids
  peer_tgw_id        = module.tgw_hq.tgw_id
  vpc_cidr           = var.sao_paulo_config.vpc_cidr
}