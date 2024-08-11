pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'my-tomcat-app:latest'           // Docker image name
        CONTAINER_NAME = 'tomcat-container'             // Docker container name
        INSTANCE_2_IP = '3.110.196.106'               // Replace with your Instance 2 IP
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/your-repo.git', branch: 'main'  // Replace with your repo URL and branch
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean package'  // Adjust for your build tool if needed
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t ${DOCKER_IMAGE} .'
            }
        }

        stage('Deploy') {
            steps {
                script {
                    sh 'docker stop ${CONTAINER_NAME} || true'
                    sh 'docker rm ${CONTAINER_NAME} || true'
                    sh 'docker run -d --name ${CONTAINER_NAME} -p 8080:8080 ${DOCKER_IMAGE}'
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    sh 'curl -I http://3.110.196.106:8080/sample'  // Replace with your app's context path
                }
            }
        }
    }

    post {
        always {
            sh 'docker rmi ${DOCKER_IMAGE} || true'
        }
    }
}
