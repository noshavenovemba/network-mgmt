pipeline {
    agent any

    environment {
        IMAGE_NAME = 'your-dockerhub-username/rancid-app'
        IMAGE_TAG = "${env.BUILD_NUMBER}"
        KUBECONFIG = credentials('kubeconfig-secret-id') // optional if you use KUBECONFIG env
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://your-repo-url.git', branch: 'main'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t $IMAGE_NAME:$IMAGE_TAG ."
            }
        }

        stage('Security Scan') {
            steps {
            sh 'trivy image --exit-code 1 --severity HIGH,CRITICAL $IMAGE_NAME:$IMAGE_TAG'
            }
        }

        stage('Push to Registry') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    sh """
                        echo "$PASSWORD" | docker login -u "$USERNAME" --password-stdin
                        docker push $IMAGE_NAME:$IMAGE_TAG
                    """
                }
            }
        }

        stage('Deploy with Helmfile') {
            steps {
                sh """
                    export IMAGE_TAG=$IMAGE_TAG
                    helmfile -e production apply
                """
            }
        }
    }

    post {
        failure {
            mail to: 'devops@example.com',
                 subject: "Jenkins Build Failed: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                 body: "Something went wrong. Check Jenkins: ${env.BUILD_URL}"
        }
    }
}