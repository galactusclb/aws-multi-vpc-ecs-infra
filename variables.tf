variable "profile" {
  description = "AWS CLI profile name Terraform should use for authentication."
  type        = string
  default     = "default"
}

variable "region" {
  description = "AWS region where all infrastructure resources are created."
  type        = string
}

variable "environment" {
  description = "Deployment environment name used for tagging and naming."
  type        = string
}

variable "common_tags" {
  description = "Map of common tags applied to all supported AWS resources."
  type        = map(string)
}

variable "availability_zones" {
  description = "Ordered list of availability zones used to place subnets and zonal resources."
  type        = list(string)
}

variable "vpc_workload_cidr" {
  description = "CIDR block for the workload VPC that hosts the internal application stack."
  type        = string
}

variable "vpc_internet_cidr" {
  description = "CIDR block for the internet-facing VPC that hosts ingress and egress components."
  type        = string
}


variable "workload_subnets" {
  description = "Map of workload VPC private subnet names to CIDR blocks."
  type        = map(string)
}

variable "internet_public_subnets" {
  description = "Map of internet VPC public subnet names to CIDR blocks."
  type        = map(string)
}

variable "internet_private_subnets" {
  description = "Map of internet VPC private subnet names to CIDR blocks."
  type        = map(string)
}

variable "rds_cluster_identifier" {
  description = "Identifier used for the Aurora cluster."
  type        = string
}

variable "rds_database_name" {
  description = "Initial database name created in the Aurora cluster."
  type        = string
}

variable "rds_master_username" {
  description = "Master username for the Aurora cluster."
  type        = string
}

variable "rds_engine_version" {
  description = "Aurora PostgreSQL engine version for the cluster."
  type        = string
}

variable "rds_instance_class" {
  description = "Instance class used for Aurora cluster instances."
  type        = string
}

variable "rds_instance_count" {
  description = "Number of Aurora cluster instances to create."
  type        = number
}
