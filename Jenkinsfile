pipeline {
    agent any  // This defines where the pipeline will run, using any available agent

    environment {
        REMOTE_SSH_CREDENTIALS_ID = 'Slave1'  // Jenkins SSH credentials ID
        REMOTE_HOST = 'http://13.201.85.186'  // Replace with your remote server address
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout the code from the GitHub repository
                git 'https://github.com/dineshkrish1607/java_deploy.git'
            }
        }

        stage('Build') {
            steps {
                // Run Maven to build the project
                sh 'mvn clean package'
            }
        }

        stage('Build Docker Image') {
            steps {
                // Build the Docker image using the Dockerfile
                script {
                    docker.build('my-sample-app:latest')
                }
            }
        }

        stage('Deploy to Remote Server') {
            steps {
                // Deploy the Docker image to the remote server using SSH
                sshagent([env.REMOTE_SSH_CREDENTIALS_ID]) {
                    sh '''
                    ssh -o StrictHostKeyChecking=no user@${REMOTE_HOST} << 'EOF'
                        docker pull my-sample-app:latest
                        docker run -d -p 8080:8080 my-sample-app:latest
                    EOF
                    '''
                }
            }
        }
    }
}
