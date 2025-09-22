pipeline {
  agent any

  environment {
    IMAGE_NAME   = "ghcr.io/noshavenovemba/network-mgmt"
    IMAGE_TAG    = "${env.BRANCH_NAME}-${env.BUILD_NUMBER}"
    REGISTRY_URL = "ghcr.io"
  }

  options {
    skipStagesAfterUnstable()
    timestamps()
    ansiColor('xterm')
  }

  stages {

    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Lint & Validate') {
      steps {
        sh '''
          echo ">>> Linting shell scripts"
          shellcheck backup.sh entrypoint.sh || true

          echo ">>> Linting Helm manifests"
          helm lint ./helmfile.yaml || true
        '''
      }
    }

    stage('Build Docker Image') {
      steps {
        sh '''
          echo ">>> Building Docker image"
          docker build -t $IMAGE_NAME:$IMAGE_TAG .
        '''
      }
    }

    stage('Push Docker Image') {
      when {
        branch 'main'
      }
      steps {
        withCredentials([usernamePassword(credentialsId: 'ghcr-creds',
                                          usernameVariable: 'REG_USER',
                                          passwordVariable: 'REG_PASS')]) {
          sh '''
            echo ">>> Logging in to registry"
            echo $REG_PASS | docker login $REGISTRY_URL -u $REG_USER --password-stdin

            echo ">>> Pushing image"
            docker push $IMAGE_NAME:$IMAGE_TAG
          '''
        }
      }
    }

    stage('Deploy to K8s') {
      when {
        branch 'main'
      }
      steps {
        withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')]) {
          sh '''
            echo ">>> Deploying with Helmfile"
            helmfile --environment production sync
          '''
        }
      }
    }
  }

  post {
    success {
      echo "✅ Pipeline finished successfully"
    }
    failure {
      echo "❌ Pipeline failed"
    }
    always {
      cleanWs()
    }
  }
}
