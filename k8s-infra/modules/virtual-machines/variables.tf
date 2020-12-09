variable "k8s_vpc_id" {
    description = "ID of VPC created in networing module"
    type        = string
}

variable "k8s_public_subnet_id" {
    description = "ID of public subnet created in networing module"
    type        = string
}

variable "k8s_private_subnet_id" {
    description = "ID of private subnet created in networing module"
    type        = string
}

variable "k8s_security_group_id" {
    description = "ID of security group created in networing module"
    type        = string
}

variable "bastion_server_ami" {
    description = "AMI for bastion server"
    type        = string
    default     = "ami-00ddb0e5626798373"
}

variable "bastion_server_instance_type" {
    description = "Instance type for bastion server"
    type        = string
    default     = "t2.micro"
}

variable "master_node_ami" {
    description = "AMI for Kubernetes Master Node"
    type        = string
    default     = "ami-00ddb0e5626798373"
}

variable "master_node_instance_type" {
    description = "Instance type for Kubernetes Master Node"
    type        = string
    default     = "t2.micro"
}

variable "worker_node_ami" {
    description = "AMI for Kubernetes Worker Node"
    type        = string
    default     = "ami-00ddb0e5626798373"
}

variable "worker_node_instance_type" {
    description = "Instance type for Kubernetes Worker Node"
    type        = string
    default     = "t2.micro"
}