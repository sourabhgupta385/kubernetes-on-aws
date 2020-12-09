variable "vpc_cidr_block" {
    description = "CIDR block for Kubernetes VPC"
    type        = string
    default     = "10.0.0.0/16"
}

variable "public_subnet_cidr_block" {
    description = "CIDR block for Kubernetes Public Subnet"
    type        = string
    default     = "10.0.0.0/24"
}

variable "private_subnet_cidr_block" {
    description = "CIDR block for Kubernetes Private Subnet"
    type        = string
    default     = "10.0.1.0/24"
}