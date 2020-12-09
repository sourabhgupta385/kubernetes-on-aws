pipeline {

  parameters {
    password (name: 'AWS_ACCESS_KEY_ID')
    password (name: 'AWS_SECRET_ACCESS_KEY')
    password (name: 'AWS_DEFAULT_REGION')
  }

  environment {
    TF_IN_AUTOMATION = 'true'
    AWS_ACCESS_KEY_ID = "${params.AWS_ACCESS_KEY_ID}"
    AWS_SECRET_ACCESS_KEY = "${params.AWS_SECRET_ACCESS_KEY}"
    AWS_DEFAULT_REGION = "${params.AWS_DEFAULT_REGION}"
  }

  agent { label 'ansible-controller-node' }
  
  stages {
    
    stage('Terraform Init') {
      steps {
        sh "cd k8s-infra && terraform init -input=false"
      }
    }
    
    stage('Terraform Plan') {
      steps {
        sh "cd k8s-infra && terraform plan -input=false -out k8s-infra-plan"
      }
    }
    
    stage('Terraform Apply') {
      input {
        message "Approval to create Kubernetes Infra"
        ok "Approve"
      }
      steps {
        sh "cd k8s-infra && terraform apply -auto-approve -input=false k8s-infra-plan"
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
