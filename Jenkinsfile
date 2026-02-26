pipeline {
    agent any

    environment {
        IMAGE_NAME = "terraform-docker-nginx-app"
        CONTAINER_NAME = "terraform-docker-nginx-app"
        SONARQUBE_SERVER = "sonarqube-server"
        SONAR_PROJECT_KEY = "terraform-docker-nginx-app"
        SONAR_PROJECT_NAME = "terraform-docker-nginx-app"
    }

    stages {

        stage('Checkout Code') {
            steps {
                slackSend(
                    color: '#439FE0',
                    message: "🚀 BUILD STARTED\nJob: ${env.JOB_NAME}\nBuild: #${env.BUILD_NUMBER}"
                )
                checkout scm
            }
        }

        stage('SonarQube Scan') {
            steps {
                withSonarQubeEnv("${SONARQUBE_SERVER}") {
                    sh """
                    sonar-scanner \
                      -Dsonar.projectKey=${SONAR_PROJECT_KEY} \
                      -Dsonar.projectName=${SONAR_PROJECT_NAME} \
                      -Dsonar.sources=app
                    """
                }
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
                sh "trivy image ${IMAGE_NAME}:latest || true"
            }
        }

        stage('Deploy Container') {
            steps {
                sh '''
                docker stop ${CONTAINER_NAME} || true
                docker rm ${CONTAINER_NAME} || true

                docker run -d \
                  -p 80:80 \
                  --name ${CONTAINER_NAME} \
                  ${IMAGE_NAME}:latest
                '''
            }
        }
    }

    post {

        success {
            slackSend(
                color: 'good',
                message: "✅ BUILD SUCCESS\nJob: ${env.JOB_NAME}\nBuild: #${env.BUILD_NUMBER}"
            )
        }

        failure {
            slackSend(
                color: 'danger',
                message: "❌ BUILD FAILED\nJob: ${env.JOB_NAME}\nBuild: #${env.BUILD_NUMBER}"
            )
        }
    }
}
