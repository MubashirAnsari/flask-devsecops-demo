pipeline {
    agent any
    environment {
        DEMO_SECRET = credentials('flask-demo-secret')
    }
    stages {
        stage('Build Docker Image') {
            steps {
                sh "docker build -t flask-demo:${BUILD_NUMBER} ."
            }
        }
        stage('Run Flask App') {
            steps {
                sh '''
                  docker ps -q --filter "ancestor=flask-demo" | grep . && docker stop $(docker ps -q --filter "ancestor=flask-demo") || echo "No container to stop"
                '''
               sh "docker run -d -e DEMO_SECRET=$DEMO_SECRET -p 7549:7549 flask-demo:${BUILD_NUMBER}"
            }
        }
    }
}
