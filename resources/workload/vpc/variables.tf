variable "cidr_block" {
  description = "CIDR block for the workload VPC."
  type        = string
}

variable "private_subnets" {
  description = "Map of workload private subnet names to CIDR blocks."
  type        = map(string)
}

variable "availability_zones" {
  description = "Ordered list of availability zones used to place workload subnets."
  type        = list(string)
}

variable "tgw-id" {
  description = "Transit gateway ID used for workload VPC route table entries."
  type        = string
}
