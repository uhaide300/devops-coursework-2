pipeline {
    agent any
    environment {
        DOCKER_IMAGE = "uhaide300/cw2-server:${BUILD_NUMBER}"
        DOCKER_CREDENTIALS = 'dockerhub-creds' // Jenkins credentials ID for DockerHub
    }
    stages {
        stage('Checkout') {
            steps {
                // Pull the latest code from GitHub
                git branch: 'main', url: git@github.com:uhaide300/devops-coursework-2.git
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image using the Dockerfile
                    docker.build("${DOCKER_IMAGE}")
                }
            }
        }
        stage('Test Docker Image') {
            steps {
                script {
                    // Run and test the container
                    sh 'docker run --name test-container -d -p 8080:8080 ${DOCKER_IMAGE}'
                    sh 'docker exec test-container curl -f http://localhost:8080'
                    sh 'docker stop test-container && docker rm test-container'
                }
            }
        }
        stage('Push Docker Image to DockerHub') {
            steps {
                withDockerRegistry([credentialsId: "${DOCKER_CREDENTIALS}", url: '']) {
                    script {
                        // Push the Docker image to DockerHub
                        docker.image("${DOCKER_IMAGE}").push()
                    }
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    // Update the Kubernetes deployment
                    sh '''
                    kubectl set image deployment/cw2-server cw2-server=${DOCKER_IMAGE} --record
                    kubectl rollout status deployment/cw2-server
                    '''
                }
            }
        }
    }
    post {
        always {
            cleanWs() // Clean the Jenkins workspace after every run
        }
    }
}
