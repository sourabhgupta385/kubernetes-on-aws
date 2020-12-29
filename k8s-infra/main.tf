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

# Create ansible inventory file 
data "template_file" "inventory" {
  template = file("${path.module}/templates/inventory.tpl")

  vars = {
    public_ip_address_bastion = join("\n", formatlist("bastion ansible_host=%s", module.virtual-machines.bastion_public_ip))
    connection_strings_master = join("\n", formatlist("master1 ansible_host=%s",  module.virtual-machines.k8s_master_private_ip))
    connection_strings_worker = join("\n", formatlist("worker1 ansible_host=%s",  module.virtual-machines.k8s_worker_private_ip))
    list_master               = join("\n", "master1")
    list_worker               = join("\n", "worker1")
  }
}

resource "null_resource" "inventories" {
  provisioner "local-exec" {
    command = "echo '${data.template_file.inventory.rendered}' > ../playbooks/hosts"
  }

  triggers = {
    template = data.template_file.inventory.rendered
  }
}

# Create SSH config file
data "template_file" "ssh_config" {
  template = file("${path.module}/templates/k8s-infra-config.tpl")

  vars = {
    public_ip_address_bastion =  join("", module.virtual-machines.bastion_public_ip)
    key_file_path             =  join("", ["/home/ubuntu/k8s-infra.pem"])
    private_ip_address_master =  join("", module.virtual-machines.k8s_master_private_ip)
    private_ip_address_worker =  join("", module.virtual-machines.k8s_worker_private_ip)
  }
}

resource "null_resource" "ssh_configs" {
  provisioner "local-exec" {
    command = "echo '${data.template_file.ssh_config.rendered}' > /home/ubuntu/.ssh/include/k8s-infra.config"
  }

  triggers = {
    template = data.template_file.ssh_config.rendered
  }
}
