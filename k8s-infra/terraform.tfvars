vpc_cidr_block             = "10.0.0.0/16"
public_subnet_cidr_blocks  = ["10.0.0.0/24", "10.0.1.0/24"]
private_subnet_cidr_blocks = ["10.0.2.0/24", "10.0.3.0/24"]

bastion_server_ami           = "ami-00ddb0e5626798373"
bastion_server_instance_type = "t2.micro"

master_nodes_num          = 3
master_node_ami           = "ami-00ddb0e5626798373"
master_node_instance_type = "t2.micro"

worker_nodes_num          = 3
worker_node_ami           = "ami-00ddb0e5626798373"
worker_node_instance_type = "t2.micro"