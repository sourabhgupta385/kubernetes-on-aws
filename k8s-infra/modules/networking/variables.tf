variable "aws_avail_zones" {
  description = "AWS Availability Zones Used"
  type        = list(string)
}

variable "vpc_cidr_block" {
  description = "CIDR block for Kubernetes VPC"
  type        = string
}

variable "public_subnet_cidr_blocks" {
  description = "CIDR block for Kubernetes Public Subnets"
  type        = list(string)
}

variable "private_subnet_cidr_blocks" {
  description = "CIDR block for Kubernetes Private Subnets"
  type        = list(string)
}
