pipeline {
    agent any
    environment {
        DEMO_SECRET = credentials('demo-secret-id')
    }
    stages {
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t flask-demo .'
            }
        }
        stage('Run Flask App') {
            steps {
                sh 'docker run -d -e DEMO_SECRET=$DEMO_SECRET -p 7549:7549 flask-demo'
            }
        }
    }
}
