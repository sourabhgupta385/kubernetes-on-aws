[all]
${connection_strings_master}
${connection_strings_worker}
${public_ip_address_bastion}

[bastion_servers]
${public_ip_address_bastion}

[kube_masters]
${list_master}


[kube_workers]
${list_worker}

[k8s_cluster]
kube-masters
kube-workers