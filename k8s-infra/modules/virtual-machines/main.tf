resource "aws_instance" "bastion_server" {
  ami                    = var.bastion_server_ami
  instance_type          = var.bastion_server_instance_type
  count                  = length(var.k8s_public_subnet_ids)
  subnet_id              = element(var.k8s_public_subnet_ids, count.index)
  availability_zone      = element(var.aws_avail_zones, count.index)
  vpc_security_group_ids = [var.k8s_security_group_id]
  key_name               = "HomeLaptop"

  tags = {
    Name = "Bastion Server"
  }
}

resource "aws_instance" "k8s_masters" {
  ami                    = var.master_node_ami
  instance_type          = var.master_node_instance_type
  count                  = var.master_nodes_num
  subnet_id              = element(var.k8s_private_subnet_ids, count.index)
  availability_zone      = element(var.aws_avail_zones, count.index)
  vpc_security_group_ids = [var.k8s_security_group_id]
  key_name               = "HomeLaptop"

  tags = {
    Name = "K8s Master Node ${count.index + 1}"
  }
}

resource "aws_instance" "k8s_workers" {
  ami                    = var.worker_node_ami
  instance_type          = var.worker_node_instance_type
  count                  = var.worker_nodes_num
  subnet_id              = element(var.k8s_private_subnet_ids, count.index)
  availability_zone      = element(var.aws_avail_zones, count.index)
  vpc_security_group_ids = [var.k8s_security_group_id]
  key_name               = "HomeLaptop"

  tags = {
    Name = "K8s Worker Node ${count.index + 1}"
  }
}
