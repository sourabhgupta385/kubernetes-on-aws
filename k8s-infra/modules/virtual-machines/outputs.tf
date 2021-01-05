output "bastion_public_ips" {
  value = aws_instance.bastion_server.*.public_ip
}

output "k8s_master_private_dns" {
  value = aws_instance.k8s_masters.*.private_dns
}

output "k8s_master_private_ips" {
  value = aws_instance.k8s_masters.*.private_ip
}

output "k8s_worker_private_dns" {
  value = aws_instance.k8s_workers.*.private_dns
}

output "k8s_worker_private_ips" {
  value = aws_instance.k8s_workers.*.private_ip
}
