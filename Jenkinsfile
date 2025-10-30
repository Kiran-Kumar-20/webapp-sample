pipeline {
  agent any

  environment {
    REGISTRY = 'docker.io'
    REPOSITORY = 'Kiran-Kumar-20/webapp-sample' // replace with your dockerhub username
    IMAGE_TAG = "${env.BUILD_NUMBER ?: 'local'}"
    IMAGE = "${REGISTRY}/${REPOSITORY}:${IMAGE_TAG}"
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build') {
      steps {
        sh 'docker --version'
        sh "docker build -t ${IMAGE} ."
      }
    }

    stage('Test (smoke)') {
      steps {
        sh '''
          cid=$(docker create -p 8080:80 ${IMAGE})
          docker start $cid
          sleep 1
          if ! docker exec $cid wget -qO- http://localhost:80 | grep -q "My WebApp"; then
            docker logs $cid || true
            docker rm -f $cid || true
            echo "Smoke test failed" >&2
            exit 1
          fi
          docker rm -f $cid || true
        '''
      }
    }

    stage('Login & Push') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-login', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
          sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin ${REGISTRY}'
          sh "docker push ${IMAGE}"
        }
      }
    }
  }

  post {
    success {
      echo "Build and push succeeded: ${IMAGE}"
    }
    failure {
      echo "Pipeline failed"
    }
    always {
      sh "docker image prune -af || true"
    }
  }
}
