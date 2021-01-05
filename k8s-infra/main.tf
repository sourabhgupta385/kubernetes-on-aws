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

# Get the AZs
data "aws_availability_zones" "available" {
  state = "available"
}

module "networking" {
  source                     = "./modules/networking"
  aws_avail_zones            = slice(data.aws_availability_zones.available.names, 0, 2)
  vpc_cidr_block             = var.vpc_cidr_block
  public_subnet_cidr_blocks  = var.public_subnet_cidr_blocks
  private_subnet_cidr_blocks = var.private_subnet_cidr_blocks
}

module "load-balancers" {
  source = "./modules/load-balancers"

  k8s_vpc_id            = module.networking.k8s_vpc_id
  k8s_public_subnet_ids = module.networking.k8s_public_subnet_ids
}

module "virtual-machines" {
  source = "./modules/virtual-machines"

  aws_avail_zones              = slice(data.aws_availability_zones.available.names, 0, 2)
  k8s_vpc_id                   = module.networking.k8s_vpc_id
  k8s_public_subnet_ids        = module.networking.k8s_public_subnet_ids
  k8s_private_subnet_ids       = module.networking.k8s_private_subnet_ids
  k8s_security_group_id        = module.networking.k8s_security_group_id
  bastion_server_ami           = var.bastion_server_ami
  bastion_server_instance_type = var.bastion_server_instance_type
  master_nodes_num             = var.master_nodes_num
  master_node_ami              = var.master_node_ami
  master_node_instance_type    = var.master_node_instance_type
  worker_nodes_num             = var.worker_nodes_num
  worker_node_ami              = var.worker_node_ami
  worker_node_instance_type    = var.worker_node_instance_type
}

resource "aws_elb_attachment" "attach_master_nodes" {
  count    = var.master_nodes_num
  elb      = module.load-balancers.k8s_api_elb_id
  instance = element(module.virtual-machines.k8s_master_ids, count.index)
}

# Create ansible inventory file 
data "template_file" "inventory" {
  template = file("${path.module}/templates/inventory.tpl")

  vars = {
    public_ip_address_bastion = join("\n", formatlist("bastion%d ansible_host=%s", range(1, length(var.public_subnet_cidr_blocks) + 1), module.virtual-machines.bastion_public_ips))
    connection_strings_master = join("\n", formatlist("master%d ansible_host=%s", range(1, var.master_nodes_num + 1), module.virtual-machines.k8s_master_private_ips))
    connection_strings_worker = join("\n", formatlist("worker%d ansible_host=%s", range(1, var.worker_nodes_num + 1), module.virtual-machines.k8s_worker_private_ips))
    list_master               = join("\n", formatlist("master%d", range(1, var.master_nodes_num + 1)))
    list_worker               = join("\n", formatlist("worker%d", range(1, var.worker_nodes_num + 1)))
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

# Create ansible vars file 
data "template_file" "ansible_vars" {
  template = file("${path.module}/templates/ansible-vars.tpl")

  vars = {
    k8s_api_elb_fqdn = module.load-balancers.k8s_api_elb_fqdn
  }
}

resource "null_resource" "vars" {
  provisioner "local-exec" {
    command = "echo '${data.template_file.inventory.rendered}' > ../playbooks/ansible-vars.yml"
  }

  triggers = {
    template = data.template_file.ansible_vars.rendered
  }
}
