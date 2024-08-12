pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'iamdineshk/my-java-app'
        DOCKER_TAG = 'latest'
        SSH_CREDENTIALS_ID = 'Slave1'
        DOCKER_HOST = 'http://13.201.85.186' // Adjust with your Docker instance IP and port if needed
    }

    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/dineshkrish1607/java_deploy.git'
            }
        }
        stage('Build with Maven') {
            steps {
                sh 'mvn clean package'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    docker.withServer("${env.DOCKER_HOST}", "${env.SSH_CREDENTIALS_ID}") {
                        docker.build("${env.DOCKER_IMAGE}:${env.DOCKER_TAG}", ".").push()
                    }
                }
            }
        }
        stage('Deploy to Docker') {
            steps {
                sshagent (credentials: ['Slave1']) {
                    sh """
                    ssh -o StrictHostKeyChecking=no ec2-user@docker-instance-ip << EOF
                    docker pull ${env.DOCKER_IMAGE}:${env.DOCKER_TAG}
                    docker stop my-java-app-container || true
                    docker rm my-java-app-container || true
                    docker run -d --name my-java-app-container -p 8080:8080 ${env.DOCKER_IMAGE}:${env.DOCKER_TAG}
                    EOF
                    """
                }
            }
        }
    }
}
