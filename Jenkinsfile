pipeline {
    agent any

    environment {
        DOCKERHUB_USERNAME = 'vasudevad' // Docker Hub username
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
                    def BRANCH = Jenkins.instance.getItemByFullName(env.JOB_NAME).getLastBuild().getBranch().getName()
                    def BUILD = env.BUILD_NUMBER
                    def IMAGE_TAG = "${BRANCH}-${BUILD}"
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
