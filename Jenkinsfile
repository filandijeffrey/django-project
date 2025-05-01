pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                // Checkout the source code from GitHub
                checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[credentialsId: 'github-login', url: 'https://github.com/filandijeffrey/django-project.git']])
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image using the Dockerfile in the repository
                    sh 'docker build -t my-django-app .'
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
                    // Push Docker image to Docker Hub
                    sh 'docker push my-django-app'
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                script {
                    // Deploy Docker container to EC2
                    sh '''
                    ssh -i /path/to/jenkins-docker.pem ec2-user@3.15.221.176 << EOF
                    docker pull my-django-app
                    docker run -d -p 8000:8000 my-django-app
                    EOF
                    '''
                }
            }
        }
    }

    post {
        always {
            // Steps to be executed always (e.g., cleanup or notification)
            echo 'Pipeline finished, cleanup or notification can be added here.'
        }
    }
}