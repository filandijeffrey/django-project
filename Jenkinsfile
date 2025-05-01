pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                // Checkout the source code from GitHub
                checkout scmGit(
                    branches: [[name: '*/main']],
                    extensions: [],
                    userRemoteConfigs: [[
                        credentialsId: 'github-login',
                        url: 'https://github.com/filandijeffrey/django-project.git'
                    ]]
                )
            }
        }

        stage('Build Docker Image') {
    steps {
        script {
            // Use correct image name for Docker Hub
            sh 'docker build -t fjeffrey/my-django-app .'
        }
    }
}
        stage('Docker Hub Login') {
            steps {
                script {
                    // Log in to Docker Hub using credentials stored in Jenkins
                    withCredentials([usernamePassword(credentialsId: 'docker-login', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh 'docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD'
                    }
                }
            }
        }

        stage('Push Docker Image') {
    steps {
        script {
            sh 'docker push fjeffrey/my-django-app'
        }
    }
}

        stage('Deploy to EC2') {
            steps {
                script {
                    // Use SSH key credentials managed by Jenkins for EC2 deployment
                    sshagent(['ec2-ssh-key']) {
                        sh '''
                        ssh -o StrictHostKeyChecking=no ec2-user@3.15.221.176 << EOF
                        docker pull my-django-app
                        docker rm -f my-django-app || true
                        docker run -d --name my-django-app -p 8000:8000 my-django-app
                        EOF
                        '''
                    }
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline finished, cleanup or notification can be added here.'
        }
    }
}
