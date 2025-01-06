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

resource "aws_rds_cluster_instance" "cluster_instances" {
  publicly_accessible = false
  force_destroy = true
  provider           = aws.osaka
  count              = 2
  identifier         = "${var.osaka_config.name}-aurora-cluster-${count.index}"
  cluster_identifier = aws_rds_cluster.default.id
  instance_class     = "db.t3.medium"
  engine             = aws_rds_cluster.default.engine
  engine_version     = aws_rds_cluster.default.engine_version
}

resource "aws_rds_cluster" "default" {
  provider               = aws.osaka
  cluster_identifier     = "${var.osaka_config.name}-aurora-cluster"
  db_subnet_group_name   = aws_db_subnet_group.osaka_subnet_group.name
  engine                 = "aurora-mysql"
  engine_version         = "8.0.mysql_aurora.3.05.2"
  database_name          = "mydb"
  master_username        = "foo"
  master_password        = "barbut8chars"
  vpc_security_group_ids = [aws_security_group.osaka-sg.id]
  storage_encrypted      = false
  skip_final_snapshot    = true
}

resource "aws_db_subnet_group" "osaka_subnet_group" {
  provider = aws.osaka
  name     = "main"

  subnet_ids = module.osaka_network.private_subnet_ids

  tags = {
    Name = "My DB subnet group"
  }
  depends_on = [ module.osaka_network ]
}

resource "aws_security_group" "osaka-sg" {
  provider    = aws.osaka
  vpc_id      = module.osaka_network.vpc_id
  name        = "${var.osaka_config.name}-db-sg"
  description = "${var.osaka_config.name}-db-sg"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }



  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}