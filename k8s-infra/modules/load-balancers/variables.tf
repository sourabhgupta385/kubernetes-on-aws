variable "k8s_vpc_id" {
  description = "ID of VPC created in networing module"
  type        = string
}

variable "k8s_public_subnet_ids" {
  description = "IDs of public subnets created in networing module"
  type        = list(string)
}
