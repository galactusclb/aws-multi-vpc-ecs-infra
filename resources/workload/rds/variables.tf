variable "cluster_identifier" {
    type = string
}
variable "engine_version" {
  type = string
  default = "16.4"
}

variable "database_name" {
    type = string
}
variable "master_username" {
    type = string
}

variable "instance_class" {
    type = string
  default = "db.t4g.medium"
}

variable "instance_count" {
  type = string
  default = 1
}

variable "vpc_id" {
    type = string
}

variable "subnet_ids" {
  type = list(string)
}


variable "referenced_security_group_id" {
  type        = string
  description = "Security groups allowed to access RDS"
}