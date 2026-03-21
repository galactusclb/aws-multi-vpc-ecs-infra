variable "vpc_id_workload" {
  type = string
}
variable "subnets_workload" {
  type = list(string)
}

variable "vpc_id_internet" {
  type = string
}
variable "subnets_internet" {
  type = list(string)
}