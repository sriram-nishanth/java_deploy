pipeline {
    agent any

    environment {
        REMOTE_SSH_CREDENTIALS_ID = 'Slave1'
        REMOTE_HOST = '172.31.17.62'
        DOCKER_IMAGE = 'my-app:latest'
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
                    docker.build(env.DOCKER_IMAGE)
                }
            }
        }

        stage('Deploy to Remote Server') {
            steps {
                echo 'Deploying Docker container to remote server...'
                sshagent([env.REMOTE_SSH_CREDENTIALS_ID]) {
                    sh """
                    ssh -o StrictHostKeyChecking=no root@${REMOTE_HOST} '
                        docker run -d -p 8080:8080 ${env.DOCKER_IMAGE}
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
    }
}
