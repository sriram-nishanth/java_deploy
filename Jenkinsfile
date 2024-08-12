pipeline {
    agent any  // Runs the pipeline on any available agent

    tools {
        maven 'Maven 3.9.8' // Name of the Maven installation in Jenkins
    }

    environment {
        REMOTE_SSH_CREDENTIALS_ID = 'Slave1'  // Jenkins SSH credentials ID
        REMOTE_HOST = '13.201.85.186'  // Remote server address (IP or hostname)
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout the code from the GitHub repository
                git url: 'https://github.com/dineshkrish1607/java_deploy.git', branch: 'main'
            }
        }

        stage('Check Maven Installation') {
            steps {
                // Check Maven installation and version
                sh '''
                echo "Checking Maven installation..."
                which mvn
                mvn -v
                '''
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
                    echo "Deploying Docker container..."
                    ssh -o StrictHostKeyChecking=no user@${REMOTE_HOST} << 'EOF'
                        docker pull my-sample-app:latest
                        docker run -d -p 8080:8080 my-sample-app:latest
                    EOF
                    '''
                }
            }
        }
    }

    post {
        always {
            // Actions to perform after the pipeline completes
            echo 'Pipeline completed'
        }
    }
}
