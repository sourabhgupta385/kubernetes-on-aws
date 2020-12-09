resource "aws_instance" "bastion_server" {
  ami                    = var.bastion_server_ami
  instance_type          = var.bastion_server_instance_type
  subnet_id              = var.k8s_public_subnet_id
  vpc_security_group_ids = [var.k8s_security_group_id]
  key_name               = "HomeLaptop"

  tags = {
    Name = "Bastion Server"
  }
}

resource "aws_instance" "k8s_master" {
  ami                    = var.master_node_ami
  instance_type          = var.master_node_instance_type
  subnet_id              = var.k8s_private_subnet_id
  vpc_security_group_ids = [var.k8s_security_group_id]
  key_name               = "HomeLaptop"

  tags = {
    Name = "K8s Master Node"
  }
}

resource "aws_instance" "k8s_worker" {
  ami                    = var.worker_node_ami
  instance_type          = var.worker_node_instance_type
  subnet_id              = var.k8s_private_subnet_id
  vpc_security_group_ids = [var.k8s_security_group_id]
  key_name               = "HomeLaptop"

  tags = {
    Name = "K8s Worker Node"
  }
}