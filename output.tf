output "internet_alb_dns_name" {
  description = "DNS name of the public internet-facing ALB."
  value       = module.internet-alb.alb_dns_name
}

output "rds_cluster_endpoint" {
  description = "Writer endpoint of the Aurora cluster."
  value       = module.rds.cluster_endpoint
}

output "workload_vpc_id" {
  description = "ID of the workload VPC."
  value       = module.vpc_workload.vpc_id
}

output "internet_vpc_id" {
  description = "ID of the internet-facing VPC."
  value       = module.vpc_internet.vpc_id
}

output "transit_gateway_id" {
  description = "ID of the transit gateway connecting the VPCs."
  value       = module.tgw.tgw-id
}

output "waf_web_acl_arn" {
  description = "ARN of the WAF web ACL associated with the internet-facing ALB."
  value       = module.waf.web_acl_arn
}
