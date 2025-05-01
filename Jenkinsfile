pipeline {
    agent any

    environment {
        EC2_HOST = 'ec2-user@3.15.221.176'
        APP_DIR = 'myproject'
        IMAGE_NAME = 'myproject:latest'
    }

    stages {
        stage('Clone Repo') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t myproject .'
            }
        }

        stage('Push to EC2 and Deploy') {
            steps {
                sshagent (credentials: ['ec2-ssh-key']) {
                    sh '''
                    scp -o StrictHostKeyChecking=no -r . $EC2_HOST:~/$APP_DIR
                    ssh -o StrictHostKeyChecking=no $EC2_HOST << EOF
                        cd $APP_DIR
                        docker stop myproject || true
                        docker rm myproject || true
                        docker build -t myproject .
                        docker run -d -p 8000:8000 --name myproject myproject
                    EOF
                    '''
                }
            }
        }
    }
}