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

# Create a Security Group
resource "aws_security_group" "jenkins_slave_security_group" {
  tags = {
    Name = "Jenkins Slave Security Group"
  }
}

resource "aws_security_group_rule" "allow-all-egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.jenkins_slave_security_group.id
}

resource "aws_security_group_rule" "allow-ssh-connections" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.jenkins_slave_security_group.id
}

resource "aws_instance" "jenkins_slave" {
  ami                    = var.jenkins_slave_ami
  instance_type          = var.jenkins_slave_instance_type
  vpc_security_group_ids = [aws_security_group.jenkins_slave_security_group.id]
  key_name               = "HomeLaptop"

  tags = {
    Name = "Jenkins Slave"
  }
}