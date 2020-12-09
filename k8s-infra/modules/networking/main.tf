# Create a VPC
resource "aws_vpc" "k8s_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "Kubernetes VPC"
  }
}

# Create a Public Subnet
resource "aws_subnet" "k8s_public_subnet" {
  vpc_id                  = aws_vpc.k8s_vpc.id
  cidr_block              = var.public_subnet_cidr_block
  map_public_ip_on_launch = true

  tags = {
    Name = "Kubernetes Public Subnet"
  }
}

# Create a Private Subnet
resource "aws_subnet" "k8s_private_subnet" {
  vpc_id                  = aws_vpc.k8s_vpc.id
  cidr_block              = var.private_subnet_cidr_block

  tags = {
    Name = "Kubernetes Private Subnet"
  }
}

# Create a Internet Gateway
resource "aws_internet_gateway" "k8s_internet_gateway" {
  vpc_id = aws_vpc.k8s_vpc.id

  tags = {
    Name = "Kubernetes Internet Gateway"
  }
}

# Create Elastic IP for NAT Gateway
resource "aws_eip" "k8s_eip_nat_gateway" {
  vpc      = true

  tags = {
    Name = "Kubernetes NAT Gateway EIP"
  }
}

# Create a NAT Gateway
resource "aws_nat_gateway" "k8s_nat_gateway" {
  allocation_id = aws_eip.k8s_eip_nat_gateway.id
  subnet_id     = aws_subnet.k8s_public_subnet.id

  tags = {
    Name = "Kubernetes NAT Gateway"
  }
}

# Create a Public Route Table
resource "aws_route_table" "k8s_public_route_table" {
  vpc_id       = aws_vpc.k8s_vpc.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.k8s_internet_gateway.id
  }

  tags = {
    Name = "K8s Public Route Table"
  }
}

# Create a Private Route Table
resource "aws_route_table" "k8s_private_route_table" {
  vpc_id       = aws_vpc.k8s_vpc.id
  
  route {
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.k8s_nat_gateway.id
  }

  tags = {
    Name = "K8s Private Route Table"
  }
}

# Associate Public Route Table with Public Subnet
resource "aws_route_table_association" "k8s_rta_public" {
  subnet_id      = aws_subnet.k8s_public_subnet.id
  route_table_id = aws_route_table.k8s_public_route_table.id
}

# Associate Private Route Table with Private Subnet
resource "aws_route_table_association" "k8s_rta_private" {
  subnet_id      = aws_subnet.k8s_private_subnet.id
  route_table_id = aws_route_table.k8s_private_route_table.id
}

# Create a Security Group
resource "aws_security_group" "k8s_security_group" {
  vpc_id      = aws_vpc.k8s_vpc.id

  tags = {
    Name = "Kubernetes Security Group"
  }
}

resource "aws_security_group_rule" "allow-all-ingress" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = [var.vpc_cidr_block]
  security_group_id = aws_security_group.k8s_security_group.id
}

resource "aws_security_group_rule" "allow-all-egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.k8s_security_group.id
}

resource "aws_security_group_rule" "allow-ssh-connections" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.k8s_security_group.id
}