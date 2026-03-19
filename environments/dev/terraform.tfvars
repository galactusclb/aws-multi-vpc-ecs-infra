profile="bit"

region = "us-east-1"
environment = "dev"
common_tags = {
    ManagedBy = "Terraform"
    Project = "aws-multi-vpc-ecs-infra"
}


vpcs = [
    "10.0.0.0/16"
]
private_subnets = {
    "web" = "10.0.1.0/24",
    "app" = "10.0.2.0/24",
    "data" = "10.0.3.0/24",
    "tgw" = "10.0.4.0/24",
}
private_subnets_availability_zone = "us-east-1a"