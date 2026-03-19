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
  availability_zone = var.private_subnets_availability_zone
}

locals {
  listener_port = 80
}
module "alb" {
  source = "./resources/workload/alb"

  vpc_id                   = module.vpc_workload.vpc_id
  subnets                  = [var.private_subnets["web"]]
  alb_sg_ingress_id        = ""
  alb_sg_ingress_from_port = local.listener_port
  alb_sg_ingress_to_port   = local.listener_port
}

module "nlb" {
  source = "./resources/workload/nlb"

  vpc_id = module.vpc_workload.vpc_id
  nlb_subnets = [var.private_subnets["web"]]

  alb_arn = module.alb.alb_arn
  listener_port= local.listener_port
}