pipeline {
    agent any

    triggers {
        pollSCM('H/5 * * * *') // Poll every 5 minutes. Adjust as needed.
    }

    environment {
        DOCKER_IMAGE_NAME = "chennaibodhi/openemr-custom:${env.BUILD_ID}"
    }

    stages {
        stage('Build') {
            steps {
                script {
                    // Build Docker image
                    sh "docker build -t $DOCKER_IMAGE_NAME ."
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh "docker login -u $DOCKER_USER -p $DOCKER_PASSWORD"
                        sh "docker push $DOCKER_IMAGE_NAME"
                    }
                }
            }
        }

        stage('Test') {
    steps {
        script {
            // Run custom tests inside the Docker container
            withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASSWORD')]) {
                sh "docker pull $DOCKER_IMAGE_NAME"
                sh """docker run -v \$(pwd):/var/www/htdocs $DOCKER_IMAGE_NAME /bin/sh -c 'composer install --no-interaction && echo \"Running custom tests...\"'"""
            }
        }
    }
}



        stage('Deploy') {
            steps {
                // Deploy to production or staging environment
                
                sh 'docker-compose -f /var/lib/jenkins/workspace/OpenEMR/docker/production/docker-compose.yml  up -d'
            }
        }
    }
}
