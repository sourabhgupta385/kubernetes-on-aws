# Create a VPC
resource "aws_vpc" "k8s_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "Kubernetes VPC"
  }
}

# Create 2 public subnets
resource "aws_subnet" "k8s_public_subnets" {
  vpc_id                  = aws_vpc.k8s_vpc.id
  count                   = length(var.aws_avail_zones)
  availability_zone       = element(var.aws_avail_zones, count.index)
  cidr_block              = element(var.public_subnet_cidr_blocks, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "Kubernetes Public Subnet ${count.index + 1}"
  }
}

# Create 2 private subnets
resource "aws_subnet" "k8s_private_subnets" {
  vpc_id            = aws_vpc.k8s_vpc.id
  count             = length(var.aws_avail_zones)
  availability_zone = element(var.aws_avail_zones, count.index)
  cidr_block        = element(var.private_subnet_cidr_blocks, count.index)

  tags = {
    Name = "Kubernetes Private Subnet ${count.index + 1}"
  }
}

# Create a internet gateway
resource "aws_internet_gateway" "k8s_internet_gateway" {
  vpc_id = aws_vpc.k8s_vpc.id

  tags = {
    Name = "Kubernetes Internet Gateway"
  }
}

# Create elastic ips for NAT gateways
resource "aws_eip" "k8s_eips_nat_gateway" {
  vpc   = true
  count = length(var.public_subnet_cidr_blocks)

  tags = {
    Name = "Kubernetes NAT Gateway EIP ${count.index + 1}"
  }
}

# Create 2 NAT gateways
resource "aws_nat_gateway" "k8s_nat_gateways" {
  count         = length(var.public_subnet_cidr_blocks)
  allocation_id = element(aws_eip.k8s_eips_nat_gateway.*.id, count.index)
  subnet_id     = element(aws_subnet.k8s_public_subnets.*.id, count.index)

  tags = {
    Name = "Kubernetes NAT Gateway ${count.index + 1}"
  }
}

# Create a public route table
resource "aws_route_table" "k8s_public_route_table" {
  vpc_id = aws_vpc.k8s_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.k8s_internet_gateway.id
  }

  tags = {
    Name = "K8s Public Route Table"
  }
}

# Create 2 private route tables
resource "aws_route_table" "k8s_private_route_tables" {
  vpc_id = aws_vpc.k8s_vpc.id
  count  = length(var.private_subnet_cidr_blocks)

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.k8s_nat_gateways.*.id, count.index)
  }

  tags = {
    Name = "K8s Private Route Table ${count.index + 1}"
  }
}

# Associate public route table with public subnets
resource "aws_route_table_association" "k8s_rta_public" {
  count          = length(var.public_subnet_cidr_blocks)
  subnet_id      = element(aws_subnet.k8s_public_subnets.*.id, count.index)
  route_table_id = aws_route_table.k8s_public_route_table.id
}

# Associate private route tables with private subnets
resource "aws_route_table_association" "k8s_rta_private" {
  count          = length(var.private_subnet_cidr_blocks)
  subnet_id      = element(aws_subnet.k8s_private_subnets.*.id, count.index)
  route_table_id = element(aws_route_table.k8s_private_route_tables.*.id, count.index)
}

# Create a security group
resource "aws_security_group" "k8s_security_group" {
  vpc_id = aws_vpc.k8s_vpc.id

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
