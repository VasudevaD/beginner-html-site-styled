pipeline {
    agent any

    environment {
        DOCKERHUB_USERNAME = 'vasudevad' // Replace with your Docker Hub username
        IMAGE_NAME = "${DOCKERHUB_USERNAME}/beginner-html-site"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build and Push Docker Image') {
            steps {
                script {
                    def BRANCH_NAME = env.BRANCH_NAME ?: 'master' // Default to 'master' if not set
                    def BUILD_NUMBER = env.BUILD_NUMBER ?: '1'      // Default to '1' if not set
                    def IMAGE_TAG = "${BRANCH_NAME}-${BUILD_NUMBER}"
                    echo "Building Docker image: ${IMAGE_NAME}:${IMAGE_TAG}"
                    docker build -t "${IMAGE_NAME}:${IMAGE_TAG}" .
                    echo "Logging in to Docker Hub using access token"
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-token', usernameVariable: 'DOCKERHUB_USERNAME', passwordVariable: 'DOCKERHUB_PASSWORD')]) {
                        sh "docker login -u \$DOCKERHUB_USERNAME -p \$DOCKERHUB_PASSWORD"
                        echo "Pushing Docker image: ${IMAGE_NAME}:${IMAGE_TAG}"
                        docker push "${IMAGE_NAME}:${IMAGE_TAG}"
                        docker tag "${IMAGE_NAME}:${IMAGE_TAG}" "${IMAGE_NAME}:latest"
                        docker push "${IMAGE_NAME}:latest"
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    echo "Applying Kubernetes deployment and service manifests"
                    sh "kubectl apply -f deployment.yaml -f service.yaml"
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
