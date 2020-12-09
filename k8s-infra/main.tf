terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

module "networking" {
  source = "./modules/networking"
}

module "virtual-machines" {
  source = "./modules/virtual-machines"

  k8s_vpc_id            = module.networking.k8s_vpc_id
  k8s_public_subnet_id  = module.networking.k8s_public_subnet_id
  k8s_private_subnet_id = module.networking.k8s_private_subnet_id
  k8s_security_group_id = module.networking.k8s_security_group_id
}
