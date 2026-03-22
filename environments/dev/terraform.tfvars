profile = "bit"

region      = "us-east-1"
environment = "dev"
common_tags = {
  ManagedBy = "Terraform"
  Project   = "aws-multi-vpc-ecs-infra"
}


vpc_workload_cidr  = "10.0.0.0/16"
vpc_internet_cidr  = "13.0.0.0/16"
availability_zones = ["us-east-1a", "us-east-1b"]
workload_subnets = {
  "web"   = "10.0.1.0/24",
  "web2"  = "10.0.2.0/24",
  "app"   = "10.0.3.0/24",
  "data"  = "10.0.4.0/24",
  "data2" = "10.0.5.0/24",
  "tgw"   = "10.0.6.0/24",
}

internet_public_subnets = {
  "gateway" : "13.0.1.0/24",
  "gateway2" : "13.0.2.0/24",
  "firewall" : "13.0.3.0/24"
}

internet_private_subnets = {
  "gateway3" : "13.0.4.0/24",
  "tgw" = "13.0.5.0/24",
}

rds_cluster_identifier = "app-aurora"
rds_database_name      = "appdb"
rds_master_username    = "dbadminuser"
rds_engine_version     = "16.4"
rds_instance_class     = "db.t4g.medium"
rds_instance_count     = 1