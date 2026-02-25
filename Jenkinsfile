pipeline {
    agent any

    environment {
        IMAGE_NAME = 'terraform-docker-ec2-autodeploy'
        CONTAINER_NAME = 'terraform-docker-ec2-autodeploy'
        SONARQUBE_SERVER = 'sonarqube-server'
    }

    stages {

        stage('Checkout Code') {
            steps {
                slackSend(
                    color: '#439FE0',
                    message: "🚀 BUILD STARTED - ${env.JOB_NAME} #${env.BUILD_NUMBER}"
                )
                checkout scm
            }
        }

        stage('SonarQube Scan (Optional)') {
            steps {
                echo "Static scan placeholder (HTML project)"
            }
        }

        stage('Build Docker Image') {
            steps {
                dir('app') {
                    sh "docker build -t ${IMAGE_NAME}:latest ."
                }
            }
        }

        stage('Trivy Security Scan') {
            steps {
                sh "trivy image --exit-code 1 --severity CRITICAL,HIGH ${IMAGE_NAME}:latest"
            }
        }

        stage('Run Container') {
            steps {
                sh """
                docker stop ${CONTAINER_NAME} || true
                docker rm ${CONTAINER_NAME} || true

                docker run -d -p 80:80 \
                --name ${CONTAINER_NAME} \
                ${IMAGE_NAME}:latest
                """
            }
        }
    }

    post {

        success {
            slackSend(color: 'good', message: "✅ BUILD SUCCESS ${env.JOB_NAME}")
        }

        failure {
            slackSend(color: 'danger', message: "❌ BUILD FAILED ${env.JOB_NAME}")
        }
    }
}
