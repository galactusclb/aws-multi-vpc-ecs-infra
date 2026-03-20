variable "profile" {
  type    = string
  default = "default"
}

variable "region" {
  description = "Environment name"
  type        = string
}

variable "environment" {
  type = string
}

variable "common_tags" {
  type = map(string)
}

variable "vpcs" {
  type = list(string)
}

variable "private_subnets" {
  type = map(string)
}

variable "availability_zones" {
  type = list(string)
}