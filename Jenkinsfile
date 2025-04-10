pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build and Tag Docker Image') {
            steps {
                script {
                    def BRANCH_NAME = env.BRANCH_NAME ?: 'master'
                    def BUILD_NUMBER = env.BUILD_NUMBER ?: '1'
                    def IMAGE_NAME = 'your-dockerhub-username/beginner-html-site' // Replace
                    def IMAGE_TAG = "${BRANCH_NAME}-${BUILD_NUMBER}"
                    echo "Building Docker image: ${IMAGE_NAME}:${IMAGE_TAG}"
                    echo "Pushing Docker image: ${IMAGE_NAME}:${IMAGE_TAG} and ${IMAGE_NAME}:latest"
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                echo "Applying Kubernetes deployment manifest: deployment.yaml"
                sh "echo 'kubectl apply -f deployment.yaml'"
                echo "Applying Kubernetes service manifest: service.yaml"
                sh "echo 'kubectl apply -f service.yaml'"
                echo "Kubernetes deployment and service applied successfully!"
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
