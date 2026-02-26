pipeline {
    agent any

    tools {
        maven 'maven3'
    }

    environment {
        IMAGE_NAME        = 'devops-observability-cicd-platform'
        CONTAINER_NAME    = 'devops-observability-cicd-platform'
        SONARQUBE_SERVER  = 'sonarqube-server'
        SONAR_PROJECT_KEY = 'devops-observability-cicd-platform'
        SONAR_PROJECT_NAME= 'devops-observability-cicd-platform'
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

        stage('Build WAR') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        /*
        ========================================
        ✅ FIXED SONARQUBE STAGE
        Uses Jenkins SonarScanner TOOL
        ========================================
        */
        stage('SonarQube Scan') {
            steps {
                script {
                    def scannerHome = tool 'sonar-scanner'
                    withSonarQubeEnv("${SONARQUBE_SERVER}") {
                        sh """
                        ${scannerHome}/bin/sonar-scanner \
                          -Dsonar.projectKey=${SONAR_PROJECT_KEY} \
                          -Dsonar.projectName=${SONAR_PROJECT_NAME} \
                          -Dsonar.sources=.
                        """
                    }
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

        stage('Prepare WAR for Docker') {
            steps {
                sh '''
                rm -rf docker-tomcat-app/webapp || true
                mkdir -p docker-tomcat-app/webapp/target
                cp webapp/target/*.war docker-tomcat-app/webapp/target/
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                dir('docker-tomcat-app') {
                    sh "docker build -t ${IMAGE_NAME}:latest ."
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                sh '''
                docker stop ${CONTAINER_NAME} || true
                docker rm ${CONTAINER_NAME} || true
                docker run -d \
                  -p 8085:8080 \
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
*SonarQube:* PASSED
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
*Check Logs:* ${env.BUILD_URL}
"""
            )
        }

        unstable {
            slackSend(
                color: 'warning',
                message: """
⚠️ *BUILD UNSTABLE*
*Job:* ${env.JOB_NAME}
*Build:* #${env.BUILD_NUMBER}
*URL:* ${env.BUILD_URL}
"""
            )
        }
    }
}
