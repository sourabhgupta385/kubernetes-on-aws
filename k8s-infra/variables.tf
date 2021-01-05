variable "vpc_cidr_block" {
  description = "CIDR block for Kubernetes VPC"
  type        = string
}

variable "public_subnet_cidr_blocks" {
  description = "CIDR block for Kubernetes Public Subnets"
  type        = list
}

variable "private_subnet_cidr_blocks" {
  description = "CIDR block for Kubernetes Private Subnets"
  type        = list
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
