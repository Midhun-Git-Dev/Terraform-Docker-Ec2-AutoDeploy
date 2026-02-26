pipeline {
    agent any

    environment {
        IMAGE_NAME = 'terraform-docker-nginx-app'
        CONTAINER_NAME = 'terraform-docker-nginx-app'
        SONARQUBE_SERVER = 'sonarqube-server'
        SONAR_PROJECT_KEY = 'terraform-docker-nginx-app'
        SONAR_PROJECT_NAME = 'terraform-docker-nginx-app'
    }

    stages {

        stage('Checkout Code') {
            steps {
                slackSend(
                    color: '#439FE0',
                    message: """
🚀 *BUILD STARTED*
*Job:* ${env.JOB_NAME}
*Build:* #${env.BUILD_NUMBER}
*URL:* ${env.BUILD_URL}
"""
                )
                checkout scm
            }
        }

        stage('SonarQube Scan') {
            steps {
                withSonarQubeEnv("${SONARQUBE_SERVER}") {
                    sh '''
                    sonar-scanner \
                    -Dsonar.projectKey=${SONAR_PROJECT_KEY} \
                    -Dsonar.projectName=${SONAR_PROJECT_NAME} \
                    -Dsonar.sources=app
                    '''
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:latest app"
            }
        }

        stage('Trivy Security Scan') {
    steps {
        sh '''
        trivy image --severity HIGH,CRITICAL --exit-code 0 terraform-docker-nginx-app:latest
        '''
    }
}

        stage('Run Docker Container') {
            steps {
                sh '''
                docker stop ${CONTAINER_NAME} || true
                docker rm ${CONTAINER_NAME} || true
                docker run -d -p 8085:80 \
                  --restart unless-stopped \
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
                message: """
✅ *BUILD SUCCESS*
*Job:* ${env.JOB_NAME}
*Build:* #${env.BUILD_NUMBER}
*URL:* ${env.BUILD_URL}
"""
            )
        }

        failure {
            slackSend(
                color: 'danger',
                message: """
❌ *BUILD FAILED*
*Job:* ${env.JOB_NAME}
*Build:* #${env.BUILD_NUMBER}
*URL:* ${env.BUILD_URL}
"""
            )
        }
    }
}
