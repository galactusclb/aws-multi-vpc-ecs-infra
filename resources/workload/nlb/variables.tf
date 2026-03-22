variable "nlb_subnets" {
  description = "List of subnet IDs where the internal workload NLB is deployed."
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID where the internal workload NLB and its security group are created."
  type        = string
}

variable "frontend_private_ips" {
  description = "Ordered list of private IPs assigned to the workload NLB subnet mappings."
  type        = list(string)
}

variable "listener_port" {
  description = "Port exposed by the workload NLB listener and target group."
  type        = number
  default     = 80
}

variable "alb_arn" {
  description = "ARN of the internal workload ALB that receives traffic from the NLB."
  type        = string
}
