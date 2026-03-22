variable "subnets" {
  description = "List of private subnet IDs where the internal workload ALB is deployed."
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID where the internal workload ALB and its security group are created."
  type        = string
}

variable "alb_sg_ingress_from_port" {
  description = "Starting port allowed inbound to the workload ALB security group."
  type        = string
}

variable "alb_sg_ingress_to_port" {
  description = "Ending port allowed inbound to the workload ALB security group."
  type        = string
}
