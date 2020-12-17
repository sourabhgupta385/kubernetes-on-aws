# Put private Keys for Kubernetes Infra in /home/ubuntu/k8s-infra.pem

# Install openjdk 8
sudo apt-get update
sudo apt-get install -y openjdk-8-jdk


# Install Terraform
wget https://releases.hashicorp.com/terraform/0.14.2/terraform_0.14.2_linux_amd64.zip
sudo apt install -y unzip
unzip terraform_0.14.2_linux_amd64.zip
sudo mv terraform /usr/bin


# Install Ansible
sudo apt update
sudo apt install -y software-properties-common
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt install -y ansible

# Check Tools Version
java -version
terraform version
ansible --version

# Create directory to store Jenkins data
mkdir jenkins-data

# Create directory to store ssh config files
mkdir ~/.ssh/include

# Create SSH config file in ~/.ssh
cat <<EOF >> /home/ubuntu/.ssh/config
Include ~/.ssh/include/*
EOF

# Change the permission of pem file by executing 
chmod 400 /home/ubuntu/k8s-infra.pem
