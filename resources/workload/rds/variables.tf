variable "cluster_identifier" {
  description = "Identifier used for the Aurora cluster."
  type        = string
}
variable "engine_version" {
  description = "Aurora PostgreSQL engine version for the cluster."
  type        = string
  default     = "16.4"
}

variable "database_name" {
  description = "Initial database name created in the cluster."
  type        = string
}
variable "master_username" {
  description = "Master username for the Aurora cluster."
  type        = string
}

variable "instance_class" {
  description = "Instance class used for Aurora cluster instances."
  type        = string
  default     = "db.t4g.medium"
}

variable "instance_count" {
  description = "Number of Aurora instances to create in the cluster."
  type        = string
  default     = 1
}

variable "vpc_id" {
  description = "VPC ID where the Aurora cluster security group is created."
  type        = string
}

variable "subnet_ids" {
  description = "List of private subnet IDs used by the Aurora DB subnet group."
  type        = list(string)
}

variable "referenced_security_group_id" {
  description = "Security groups allowed to access RDS"
  type        = string
}
