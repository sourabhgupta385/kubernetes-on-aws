# Security group for kubernetes api load balancer
resource "aws_security_group" "k8s_api_elb_sg" {
  vpc_id = var.k8s_vpc_id

  tags = {
    Name = "Kubernetes API Load Balancer SG"
  }
}

resource "aws_security_group_rule" "aws-allow-api-access" {
  type              = "ingress"
  from_port         = 6443
  to_port           = 6443
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.k8s_api_elb_sg.id
}

resource "aws_security_group_rule" "aws-allow-api-egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.k8s_api_elb_sg.id
}

# AWS ELB for K8S API
resource "aws_elb" "k8s_api_elb" {
  subnets         = var.k8s_public_subnet_ids
  security_groups = [aws_security_group.k8s_api_elb_sg.id]

  listener {
    instance_port     = 6443
    instance_protocol = "tcp"
    lb_port           = 6443
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTPS:6443/healthz"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "Kubernetes API Load Balancer"
  }
}
