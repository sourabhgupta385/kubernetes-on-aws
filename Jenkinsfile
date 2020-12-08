pipeline {
	agent { label 'ansible-controller-node' }
	stages {

		stage('Echo Anything') {
			steps {
				checkout scm
				sh 'echo "Hello World!!!"'
			}
		}
	}
}
