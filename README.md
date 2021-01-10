# Kubernetes On AWS

This project provides scripts to install Kubernetes on AWS using Terraform, Ansible and Jenkins.

## Overview

This project has:

-   One Terraform script `jenkins-slave` which creates an EC2 VM in default VPC
-   Another Terraform script `k8s-infra` which creates all resources and networking components for Kubernetes cluster
-   Ansible script `playbooks` which installs Kubernetes cluster.
-   A Jenkins pipeline script `Jenkinsfile` which automates creation of infrastructure using Terraform and installation of kubernetes cluster using Ansible.

This project will create:

-   An EC2 VM in default VPC which acts as a Jenkins slave
-   VPC with public and private subnets
-   Bastion hosts and NAT Gateways in public subnets
-   Kubernetes master and worker nodes in private subnets
-   A load balancer for kubernetes API

## Architecture

<p align="center">
  <img src="docs\HA Kubernetes Cluster.png" width="700" align="center">
</p>

## How to Use

-   Create one Jenkins slave by following the steps [here](jenkins-slave/README.md)
-   Create one pipeline project in Jenkins and trigger the pipeline by supplying AWS credentials
-   Provide approvals when needed in pipeline and your Kubernetes cluster will be ready in 7-8 minutes
