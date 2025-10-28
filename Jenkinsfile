pipeline {
  agent any

  environment {
    IMAGE = "yasminnaila/andkasir"
    TAG = "${env.BUILD_NUMBER}"
    DOCKERHUB_CREDENTIALS = 'dockerhub-cred' // buat di Jenkins Credentials
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build (Ant)') {
      steps {
        sh 'ant -f build.xml jar || ant -f build.xml'
        sh 'ls -la'
      }
    }

    stage('Build Docker Image') {
      steps {
        sh "docker build -t ${IMAGE}:${TAG} ."
        sh "docker tag ${IMAGE}:${TAG} ${IMAGE}:latest"
      }
    }

    stage('Push to Docker Hub') {
      steps {
        withCredentials([usernamePassword(credentialsId: "${DOCKERHUB_CREDENTIALS}", usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
          sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
          sh "docker push ${IMAGE}:${TAG}"
          sh "docker push ${IMAGE}:latest"
        }
      }
    }
  }

  post {
    success {
      echo "Build and push successful: ${IMAGE}:${TAG}"
    }
    failure {
      echo "Build failed"
    }
  }
}
