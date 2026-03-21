variable "subnets" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "alb_sg_ingress_from_port" {
  type = string
}

variable "alb_sg_ingress_to_port" {
  type = string
}
