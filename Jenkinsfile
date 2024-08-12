pipeline {
    agent any

    environment {
        REMOTE_SSH_CREDENTIALS_ID = 'Slave1'
        REMOTE_HOST = '13.201.85.186'
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out code from GitHub...'
                git url: 'https://github.com/dineshkrish1607/java_deploy.git', branch: 'main'
            }
        }

        stage('Build') {
            steps {
                echo 'Building the project with Maven inside Docker...'
                script {
                    docker.image('maven:3.8.3-openjdk-17').inside {
                        sh 'mvn clean package'
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image...'
                script {
                    docker.build('my-app:latest')
                }
            }
        }

        stage('Deploy to Remote Server') {
            steps {
                echo 'Deploying Docker container to remote server...'
                sshagent([env.REMOTE_SSH_CREDENTIALS_ID]) {
                    sh '''
                    ssh -t -o StrictHostKeyChecking=no ubuntu@${REMOTE_HOST} << 'EOF'
                        echo "Pulling Docker image on remote server..."
                        docker pull my-app:latest
                        echo "Running Docker container on remote server..."
                        docker run -d -p 8080:8080 my-app:latest
                    EOF
                    '''
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline completed'
        }
    }
}
