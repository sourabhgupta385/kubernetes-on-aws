output "bastion_public_ip" {
  value = aws_instance.bastion_server.*.public_ip
}

output "k8s_master_private_dns" {
  value = aws_instance.k8s_master.*.private_dns
}

output "k8s_master_private_ip" {
  value = aws_instance.k8s_master.*.private_ip
}

output "k8s_worker_private_dns" {
  value = aws_instance.k8s_worker.*.private_dns
}

output "k8s_worker_private_ip" {
  value = aws_instance.k8s_worker.*.private_ip
}