pipeline {
    agent any

    environment {
        REMOTE_SSH_CREDENTIALS_ID = 'Slave1'
        REMOTE_HOST = '13.201.85.186'
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/dineshkrish1607/java_deploy.git', branch: 'main'
            }
        }

        stage('Check Maven Installation') {
            steps {
                sh '''
                echo "Checking Maven installation..."
                which mvn
                mvn -v
                '''
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build('my-sample-app:latest')
                }
            }
        }

        stage('Deploy to Remote Server') {
            steps {
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
            echo 'Pipeline completed'
        }
    }
}
