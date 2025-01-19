pipeline {
    agent any

    environment {
        REMOTE_SSH_CREDENTIALS_ID = 'Slave1'
        REMOTE_HOST = '172.31.17.62'
        DOCKER_IMAGE = 'my-app:latest'
    }

    triggers {
        githubPush() // Automatically triggers the pipeline on a GitHub push event
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

        stage('Test') {
            steps {
                echo 'Running tests...'
                script {
                    docker.image('maven:3.8.3-openjdk-17').inside {
                        sh 'mvn test'
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image...'
                script {
                    docker.build(env.DOCKER_IMAGE)
                    sh 'docker tag my-app:latest 172.31.17.62:5000/my-app:latest'
                    sh 'docker push 172.31.17.62:5000/my-app:latest'
                }
            }
        }

        stage('Deploy to Remote Server') {
            steps {
                echo 'Deploying Docker container to remote server...'
                sshagent([env.REMOTE_SSH_CREDENTIALS_ID]) {
                    sh """
                    ssh -o StrictHostKeyChecking=no root@${REMOTE_HOST} '
                        if docker pull 172.31.17.62:5000/my-app:latest; then
                            docker stop my-app || true &&
                            docker rm my-app || true &&
                            docker run -d --name my-app -p 8080:8080 172.31.17.62:5000/my-app:latest
                        else
                            echo "Docker image not found"
                        fi
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
        success {
            echo 'Deployment was successful!'
        }
        failure {
            echo 'Deployment failed. Please check the Jenkins logs for more details.'
        }
    }
}
