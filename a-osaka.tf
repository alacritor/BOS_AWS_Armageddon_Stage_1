provider "aws" {
  alias  = "osaka"
  region = var.osaka_config.region
}

module "osaka_network" {
  source = "./modules/osaka_network"

  region              = var.osaka_config.region
  name                = var.osaka_config.name
  vpc_cidr            = var.osaka_config.vpc_cidr
  private_subnet_cidr = var.osaka_config.private_subnet_cidr
  tgw_id              = module.osaka_tgw_branch.tgw_id
}

# module "osaka_frontend" {
#   source = "./modules/frontend"

#   region            = var.osaka_config.region
#   name              = var.osaka_config.name
#   vpc_id            = module.osaka_network.vpc_id
#   public_subnet_ids = module.osaka_network.public_subnet_ids
#   target_group_arn  = module.osaka_backend.target_group_arn
# }

# module "osaka_backend" {
#   source = "./modules/backend"

#   region                = var.osaka_config.region
#   name                  = var.osaka_config.name
#   vpc_id                = module.osaka_network.vpc_id
#   private_subnet_ids    = module.osaka_network.private_subnet_ids
#   frontend_sg_id        = module.osaka_frontend.frontend_sg_id
#   backend_instance_type = var.backend_config.backend_instance_type[0]
#   desired_capacity      = var.backend_config.desired_capacity
#   scaling_range         = var.backend_config.scaling_range
#   user_data             = var.backend_config.user_data
# }

module "osaka_tgw_branch" {
  source = "./modules/tgw_branch"

  providers = {
    aws.default = aws.osaka
    aws.tokyo   = aws.tokyo
  }

  region             = var.osaka_config.region
  name               = var.osaka_config.name
  vpc_id             = module.osaka_network.vpc_id
  private_subnet_ids = module.osaka_network.private_subnet_ids
  peer_tgw_id        = module.tgw_hq.tgw_id
  vpc_cidr           = var.osaka_config.vpc_cidr
}

