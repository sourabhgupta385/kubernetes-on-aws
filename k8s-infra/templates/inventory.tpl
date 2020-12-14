[all]
${connection_strings_master}
${connection_strings_worker}
${public_ip_address_bastion}

[bastion]
${public_ip_address_bastion}

[kube-master]
${list_master}


[kube-worker]
${list_worker}

[k8s-cluster:children]
kube-worker
kube-master