variable "cidr_block" {
  type = string
}

variable "public_subnets" {
  type = map(string)
}

variable "private_subnets" {
  type = map(string)
}

variable "availability_zones" {
  type = list(string)
}

variable "nat_gateway_public_subnet_key" {
  type = string
}

variable "tgw-id" {
  type = string
}

variable "vpc_workload_cidr" {
  type = string
}