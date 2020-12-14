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

data "template_file" "inventory" {
  template = file("${path.module}/templates/inventory.tpl")

  vars = {
    public_ip_address_bastion = join("\n", formatlist("bastion ansible_host=%s", module.virtual-machines.bastion_public_ip))
    connection_strings_master = join("\n", formatlist("%s ansible_host=%s", module.virtual-machines.k8s_master_private_dns, module.virtual-machines.k8s_master_private_ip))
    connection_strings_worker = join("\n", formatlist("%s ansible_host=%s", module.virtual-machines.k8s_worker_private_dns, module.virtual-machines.k8s_worker_private_ip))
    list_master               = join("\n", module.virtual-machines.k8s_master_private_dns)
    list_worker               = join("\n", module.virtual-machines.k8s_worker_private_dns)
  }
}

resource "null_resource" "inventories" {
  provisioner "local-exec" {
    command = "echo '${data.template_file.inventory.rendered}' > ./inventory/hosts"
  }

  triggers = {
    template = data.template_file.inventory.rendered
  }
}
