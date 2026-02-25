pipeline {
    agent any

    environment {
        IMAGE_NAME = 'midhun07/terraform-docker-ec2-autodeploy'
        SONARQUBE_SERVER = 'sonarqube-server'
        SONAR_PROJECT_KEY = 'terraform-docker-ec2-autodeploy'
        SONAR_PROJECT_NAME = 'terraform-docker-ec2-autodeploy'
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

        stage('SonarQube Code Scan') {
            steps {
                withSonarQubeEnv("${SONARQUBE_SERVER}") {
                    sh """
                    sonar-scanner \
                    -Dsonar.projectKey=${SONAR_PROJECT_KEY} \
                    -Dsonar.projectName=${SONAR_PROJECT_NAME}
                    """
                }
            }
        }

        stage('Quality Gate Check') {
            steps {
                timeout(time: 10, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
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
                sh "trivy image ${IMAGE_NAME}:latest"
            }
        }

        stage('Push Image to DockerHub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh """
                    echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                    docker push ${IMAGE_NAME}:latest
                    """
                }
            }
        }

        stage('Terraform Deploy') {
            steps {
                dir('terraform') {
                    sh """
                    terraform init
                    terraform apply -auto-approve
                    """
                }
            }
        }
    }

    post {

        success {
            slackSend(
                color: 'good',
                message: """
✅ *BUILD SUCCESS*
*Docker + Terraform Deploy Completed*
*Job:* ${env.JOB_NAME}
*Build:* #${env.BUILD_NUMBER}
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
"""
            )
        }
    }
}
