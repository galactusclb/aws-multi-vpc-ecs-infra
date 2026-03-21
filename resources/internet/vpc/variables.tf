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

variable "workload_vpc_cidr" {
  type = string
}

variable "transit_gateway_id" {
  type = string
}

# variable "dependency_transit_gateway_arn" {
#   type = string
# }
