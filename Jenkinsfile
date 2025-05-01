pipeline {
    agent any

    environment {
        EC2_HOST = 'ec2-user@3.15.221.176'      
        IMAGE_NAME = 'myproject:latest'
        CONTAINER_NAME = 'myproject'
        REMOTE_DIR = '~/myproject'
        DOCKERHUB_REPO = 'fjeffrey/myproject' 
        DOCKERHUB_CREDENTIALS = 'docker-login' 
    }

    stages {
        stage('Checkout Code') {
            steps {
                // Clone the code from GitHub repository
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                // Build Docker image from the Dockerfile in the repository
                script {
                    sh 'docker build -t $IMAGE_NAME .'
                }
            }
        }

        stage('Login to Docker Hub') {
            steps {
                // Login to Docker Hub
                withCredentials([usernamePassword(credentialsId: 'docker-login', passwordVariable: 'DOCKER_PASSWORD')]) {
                    script {
                        sh """
                        echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin
                        """
                    }
                }
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                // Push the built image to Docker Hub
                script {
                    sh 'docker tag $IMAGE_NAME $DOCKERHUB_REPO'
                    sh 'docker push $DOCKERHUB_REPO'
                }
            }
        }

        stage('Deploy to EC2 and Run Container') {
            steps {
                sshagent (credentials: ['ec2-ssh-key']) { // 'ec2-ssh-key' should match your Jenkins credentials ID
                    sh '''
                    echo "Copying files to EC2..."
                    scp -o StrictHostKeyChecking=no -r . $EC2_HOST:$REMOTE_DIR

                    echo "Logging into EC2 and running Docker container..."
                    ssh -o StrictHostKeyChecking=no $EC2_HOST << EOF
                        cd $REMOTE_DIR
                        docker pull $DOCKERHUB_REPO
                        docker stop $CONTAINER_NAME || true
                        docker rm $CONTAINER_NAME || true
                        docker run -d -p 8000:8000 --name $CONTAINER_NAME $DOCKERHUB_REPO
                    EOF
                    '''
                }
            }
        }
    }

    post {
        always {
            // Clean up actions (if needed)
        }
    }
}
