output "k8s_api_elb_id" {
  value = aws_elb.k8s_api_elb.id
}

output "k8s_api_elb_fqdn" {
  value = aws_elb.k8s_api_elb.dns_name
}
