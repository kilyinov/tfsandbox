variable "region" {
  default = "ap-southeast-2"
}

variable "vpc_id" {
  description = "ID of existing VPC"
  type        = string
}

variable "subnet_ids" {
  description = "Comma-separated list of subnet IDs for EKS cluster and node group"
  type        = string
}

locals {
  subnet_list = split(",", var.subnet_ids)
}