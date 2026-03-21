variable "vpc_id" {
  type = string
}

variable "subnets" {
  type = list(string)
}

variable "workload_vpc_cidr" {
  type = string
}

variable "workload_nlb_name" {
  type = string
}
