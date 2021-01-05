output "k8s_vpc_id" {
  value = aws_vpc.k8s_vpc.id
}

output "k8s_public_subnet_ids" {
  value = aws_subnet.k8s_public_subnets.*.id
}

output "k8s_private_subnet_ids" {
  value = aws_subnet.k8s_private_subnets.*.id
}

output "k8s_security_group_id" {
  value = aws_security_group.k8s_security_group.id
}
