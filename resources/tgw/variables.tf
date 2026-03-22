variable "vpc_id_workload" {
  description = "ID of the workload VPC attached to the transit gateway."
  type        = string
}
variable "subnets_workload" {
  description = "List of workload VPC subnet IDs used for the transit gateway attachment."
  type        = list(string)
}

variable "vpc_id_internet" {
  description = "ID of the internet VPC attached to the transit gateway."
  type        = string
}
variable "subnets_internet" {
  description = "List of internet VPC subnet IDs used for the transit gateway attachment."
  type        = list(string)
}
