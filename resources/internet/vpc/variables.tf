variable "cidr_block" {
  type = string
}

variable "subnets" {
  type = map(string)
}

variable "availability_zones" {
  type = list(string)
}