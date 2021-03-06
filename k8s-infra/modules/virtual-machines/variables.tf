variable "aws_avail_zones" {
  description = "AWS Availability Zones Used"
  type        = list(string)
}

variable "k8s_vpc_id" {
  description = "ID of VPC created in networing module"
  type        = string
}

variable "k8s_public_subnet_ids" {
  description = "IDs of public subnets created in networing module"
  type        = list(string)
}

variable "k8s_private_subnet_ids" {
  description = "IDs of private subnets created in networing module"
  type        = list(string)
}

variable "k8s_security_group_id" {
  description = "ID of security group created in networing module"
  type        = string
}

variable "bastion_server_ami" {
  description = "AMI for bastion server"
  type        = string
}

variable "bastion_server_instance_type" {
  description = "Instance type for bastion server"
  type        = string
}

variable "master_nodes_num" {
  description = "Number of master nodes"
}

variable "master_node_ami" {
  description = "AMI for kubernetes master node"
  type        = string
}

variable "master_node_instance_type" {
  description = "Instance type for kubernetes master node"
  type        = string
}

variable "worker_nodes_num" {
  description = "Number of worker nodes"
}

variable "worker_node_ami" {
  description = "AMI for kubernetes worker node"
  type        = string
}

variable "worker_node_instance_type" {
  description = "Instance type for kubernetes worker node"
  type        = string
}
