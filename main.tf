provider "aws" {
  profile = var.profile
  region  = var.region

  default_tags {
    tags = merge(
      var.common_tags,
      {
        Environment = var.environment
      }
    )
  }
}

// Workload VPC
module "vpc_workload" {
  source = "./resources/workload/vpc"

  cidr_block         = var.vpc_workload_cidr
  private_subnets    = var.workload_subnets
  availability_zones = var.availability_zones

  tgw-id = module.tgw.tgw-id
}

locals {
  listener_port = 80
}

module "alb" {
  source = "./resources/workload/alb"

  vpc_id = module.vpc_workload.vpc_id
  subnets = [
    module.vpc_workload.private_subnet_ids["web"],
    module.vpc_workload.private_subnet_ids["web2"]
  ]
  alb_sg_ingress_from_port = local.listener_port
  alb_sg_ingress_to_port   = local.listener_port
}

module "nlb" {
  source = "./resources/workload/nlb"

  vpc_id = module.vpc_workload.vpc_id
  nlb_subnets = [
    module.vpc_workload.private_subnet_ids["web"],
    module.vpc_workload.private_subnet_ids["web2"],
  ]

  alb_arn       = module.alb.alb_arn
  listener_port = local.listener_port
  frontend_private_ips = var.workload_nlb_frontend_private_ips

  depends_on = [module.ecs]
}

module "rds" {
  source = "./resources/workload/rds"

  cluster_identifier = var.rds_cluster_identifier
  engine_version     = var.rds_engine_version
  database_name      = var.rds_database_name
  master_username    = var.rds_master_username
  instance_class     = var.rds_instance_class
  instance_count     = var.rds_instance_count

  vpc_id = module.vpc_workload.vpc_id
  subnet_ids = [
    module.vpc_workload.private_subnet_ids["data"],
    module.vpc_workload.private_subnet_ids["data2"],
  ]

  referenced_security_group_id = module.ecs.ecs_sg_id
}

module "ecs" {
  source = "./resources/workload/ecs"

  vpc_id  = module.vpc_workload.vpc_id
  subnets = [module.vpc_workload.private_subnet_ids["app"]]

  alb_arn       = module.alb.alb_arn
  alb_sg_id     = module.alb.alb_sg_id
  listener_port = local.listener_port

  db_endpoint = module.rds.cluster_endpoint
}

// Internet VPC
module "vpc_internet" {
  source = "./resources/internet/vpc"

  cidr_block                    = var.vpc_internet_cidr
  availability_zones            = var.availability_zones
  private_subnets               = var.internet_private_subnets
  public_subnets                = var.internet_public_subnets
  nat_gateway_public_subnet_key = "gateway"

  tgw-id            = module.tgw.tgw-id
  vpc_workload_cidr = module.vpc_workload.vpc_cidr
}

module "internet-alb" {
  source = "./resources/internet/alb"

  subnets = [
    module.vpc_internet.public_subnet_ids["gateway"],
    module.vpc_internet.public_subnet_ids["gateway2"],
  ]

  vpc_id                   = module.vpc_internet.vpc_id
  workload_vpc_cidr        = module.vpc_workload.vpc_cidr
  workload_nlb_name        = module.nlb.nlb_name
  workload_nlb_private_ips = var.workload_nlb_frontend_private_ips

  depends_on = [module.nlb]
}

module "tgw" {
  source = "./resources/common/tgw"

  vpc_id_workload  = module.vpc_workload.vpc_id
  subnets_workload = [module.vpc_workload.private_subnet_ids["tgw"]]

  vpc_id_internet  = module.vpc_internet.vpc_id
  subnets_internet = [module.vpc_internet.private_subnet_ids["tgw"]]
}


# Firewalls
module "waf" {
  source = "./resources/common/waf"

  internet-alb-arn = module.internet-alb.alb_arn
}
