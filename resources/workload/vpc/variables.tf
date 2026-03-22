variable "cidr_block" {
  type = string
}

variable "private_subnets" {
  type = map(string)
}

variable "availability_zones" {
  type = list(string)
}

variable "tgw-id" {
  type = string
}