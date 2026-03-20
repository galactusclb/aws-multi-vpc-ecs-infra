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

module "vpc_workload" {
  source = "./resources/workload/vpc"

  cidr_block        = var.vpcs[0]
  private_subnets   = var.private_subnets
  availability_zones = var.availability_zones
}

locals {
  listener_port = 80
}
module "alb" {
  source = "./resources/workload/alb"

  vpc_id                   = module.vpc_workload.vpc_id
  subnets                  = [
    module.vpc_workload.private_subnet_ids["web"],
    module.vpc_workload.private_subnet_ids["web2"]
  ]
  alb_sg_ingress_id        = module.nlb.nlb_sg_id
  alb_sg_ingress_from_port = local.listener_port
  alb_sg_ingress_to_port   = local.listener_port
}

module "nlb" {
  source = "./resources/workload/nlb"

  vpc_id = module.vpc_workload.vpc_id
  nlb_subnets = [module.vpc_workload.private_subnet_ids["web"]]

  alb_arn = module.alb.alb_arn
  listener_port= local.listener_port
  alb_listener_dependency = module.alb.alb_arn
}

module "ecs" {
  source = "./resources/workload/ecs"

  vpc_id = module.vpc_workload.vpc_id
  subnets = [module.vpc_workload.private_subnet_ids["app"]]

  alb_arn = module.alb.alb_arn
  alb_sg_id = module.alb.alb_sg_id
  listener_port = local.listener_port
}