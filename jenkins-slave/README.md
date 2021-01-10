# Jenkins Slave Preparation Steps

-   Create one EC2 instance that will act as Jenkins Slave
-   Perform below step in `jenkins-slave` directory:

```
$ terraform init
$ terraform apply
```

-   Login to AWS console and create one key pair in the region where you want to deploy Kubernetes cluster. NOTE: I am using key pair with name `HomeLaptop` in this project
-   Download the PPK and convert PPK into PEM also
-   Login to Jenkins slave created above using Putty or SSH
-   Put the PEM file at `/home/ubuntu/k8s-infra.pem` on Jenkins slave
-   Copy the content of `prepare-slave.sh` and put it in `/home/ubuntu/prepare.sh` on Jenkins slave
-   Execute `prepare.sh`:

```
$ sh /home/ubuntu/prepare.sh
```

-   Once above steps are done, add this EC2 instance as slave in Jenkins with label `ansible-controller-node`
