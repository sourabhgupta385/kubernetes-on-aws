pipeline {

  parameters {
    password (name: 'AWS_ACCESS_KEY_ID')
    password (name: 'AWS_SECRET_ACCESS_KEY')
    string (name: 'AWS_DEFAULT_REGION', defaultValue: 'us-east-1')
  }

  environment {
    TF_IN_AUTOMATION = 'true'
    AWS_ACCESS_KEY_ID = "${params.AWS_ACCESS_KEY_ID}"
    AWS_SECRET_ACCESS_KEY = "${params.AWS_SECRET_ACCESS_KEY}"
    AWS_DEFAULT_REGION = "${params.AWS_DEFAULT_REGION}"
  }

  agent { label 'ansible-controller-node' }
  
  stages {
    
    // stage('Terraform Init') {
    //   steps {
    //     sh "cd k8s-infra && terraform init -input=false"
    //   }
    // }
    
    // stage('Terraform Plan') {
    //   steps {
    //     sh "cd k8s-infra && terraform plan -input=false -out k8s-infra-plan"
    //   }
    // }
    
    // stage('Terraform Apply') {
    //   input {
    //     message "Approval to create Kubernetes Infra"
    //     ok "Approve"
    //   }
    //   steps {
    //     sh "cd k8s-infra && terraform apply -auto-approve -input=false k8s-infra-plan"
    //   }
    // }

    // stage('Check Ansible Connectivity') {
    //   steps {
    //     sh "cd playbooks && ansible-playbook test-connectivity.yml -i ./hosts"
    //   }
    // }

    // stage('Install Kubernetes Dependencies') {
    //   steps {
    //     sh "cd playbooks && ansible-playbook kube-dependencies.yml -i ./hosts"
    //   }
    // }

    stage('Initialize Kubernetes Cluster & Install Flannel') {
      steps {
        sh "cd playbooks && ansible-playbook initialize-cluster.yml -i ./hosts"
        sh "cd playbooks && ansible-playbook copy-files.yml -i ./hosts"
      }
    }

    stage('Terraform Destroy') {
      input {
        message "Approval to delete Kubernetes Infra"
        ok "Approve"
      }
      steps {
        sh "cd k8s-infra && terraform destroy -auto-approve"
      }
    }
  }
}
