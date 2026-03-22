variable "vpc_id" {
  description = "VPC ID where the internet-facing ALB and its security group are created."
  type        = string
}

variable "subnets" {
  description = "List of public subnet IDs where the internet-facing ALB is deployed."
  type        = list(string)
}

variable "workload_vpc_cidr" {
  description = "CIDR block of the workload VPC allowed as egress from the internet ALB."
  type        = string
}

variable "workload_nlb_name" {
  description = "Name of the internal workload NLB used to discover and register its private IPs."
  type        = string
}

variable "workload_nlb_private_ips" {
  description = "List of private IPs registered in the internet ALB target group for the workload NLB."
  type        = list(string)
}
