variable "vpc_id" {
  description = "VPC ID where the ECS service and its security group are created."
  type        = string
}

variable "subnets" {
  description = "List of private subnet IDs where ECS tasks are launched."
  type        = list(string)
}

variable "alb_sg_id" {
  description = "Security group ID of the internal workload ALB."
  type        = string
}

variable "alb_arn" {
  description = "ARN of the internal workload ALB used by the ECS listener."
  type        = string
}

variable "listener_port" {
  description = "Port exposed by the workload ALB listener for the ECS service."
  type        = number
}

variable "db_endpoint" {
  description = "Database endpoint injected into the ECS task configuration."
  type        = string
}
