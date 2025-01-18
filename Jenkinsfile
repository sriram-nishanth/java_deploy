pipeline {
    agent any

    environment {
        REMOTE_SSH_CREDENTIALS_ID = 'Slave1'
        REMOTE_HOST = '172.31.26.195'
        DOCKER_IMAGE = 'my-app:latest'
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out code from GitHub...'
                git url: 'https://github.com/sriram-nishanth/java_deploy.git', branch: 'main'
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
                    docker.build(env.DOCKER_IMAGE, '.')
                }
            }
        }

        stage('Deploy to Remote Server') {
            steps {
                echo 'Deploying Docker container to remote Amazon Linux server...'
                sshagent([env.REMOTE_SSH_CREDENTIALS_ID]) {
                    sh """
                    ssh -o StrictHostKeyChecking=no ec2-user@${REMOTE_HOST} '
                        # Ensure Docker is installed
                        sudo yum update -y
                        sudo yum install -y docker
                        sudo systemctl start docker
                        sudo systemctl enable docker
                        
                        # Deploy Docker container
                        docker pull ${env.DOCKER_IMAGE} || echo "Image not found, skipping pull";
                        docker stop my-app || echo "Container not running, skipping stop";
                        docker rm my-app || echo "Container does not exist, skipping remove";
                        docker run -d --name my-app -p 8080:8080 ${env.DOCKER_IMAGE}
                    '
                    """
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline completed'
        }
        failure {
            echo 'Pipeline failed'
        }
    }
}
