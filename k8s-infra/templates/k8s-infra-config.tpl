Host ${public_ip_address_bastion}
  User ubuntu
  IdentityFile ${key_file_path}
  Hostname ${public_ip_address_bastion}
  StrictHostKeyChecking no

Host ${private_ip_address_master}
  ProxyCommand ssh -i ${key_file_path} ubuntu@${public_ip_address_bastion} nc %h %p