variable "cidr_block" {
  description = "CIDR block for the internet-facing VPC."
  type        = string
}

variable "public_subnets" {
  description = "Map of public subnet names to CIDR blocks in the internet VPC."
  type        = map(string)
}

variable "private_subnets" {
  description = "Map of private subnet names to CIDR blocks in the internet VPC."
  type        = map(string)
}

variable "availability_zones" {
  description = "Ordered list of availability zones used to place internet VPC subnets."
  type        = list(string)
}

variable "nat_gateway_public_subnet_key" {
  description = "Key of the public subnet where the NAT gateway should be created."
  type        = string
}

variable "tgw-id" {
  description = "Transit gateway ID used for internet VPC route table entries."
  type        = string
}

variable "vpc_workload_cidr" {
  description = "CIDR block of the workload VPC used for TGW routes from the internet VPC."
  type        = string
}
