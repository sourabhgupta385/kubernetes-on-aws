Host ${public_ip_address_bastion}
  User ubuntu
  IdentityFile ${key_file_path}
  Hostname ${public_ip_address_bastion}
  StrictHostKeyChecking no

Host ${private_subnet}
  User ubuntu
  IdentityFile ${key_file_path}
  ProxyCommand ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -W %h:%p ubuntu@${public_ip_address_bastion} -i ${key_file_path}