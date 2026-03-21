variable "nlb_subnets" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "listener_port" {
  type    = number
  default = 80
}

variable "alb_arn" {
  type        = string
  description = "ALB arn of NLB forward traffic to"
}
