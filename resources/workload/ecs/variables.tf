variable "vpc_id" {
  type = string
}

variable "subnets" {
  type = list(string)
}

variable "alb_sg_id" {
  type = string
}

variable "alb_arn" {
  type = string
}

variable "listener_port" {
  type = number
}

variable "db_endpoint" {
  type = string
}