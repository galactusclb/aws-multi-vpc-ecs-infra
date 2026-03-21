variable "cidr_block" {
  type = string
}

variable "private_subnets" {
  type = map(string)
}

variable "availability_zones" {
  type = list(string)
}

variable "internet_vpc_cidr" {
  type = string
}

variable "transit_gateway_id" {
  type = string
}