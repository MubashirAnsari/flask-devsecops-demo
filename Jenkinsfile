pipeline {
    agent any
    environment {
        // DEMO_SECRET is securely fetched using the credentials plugin
    }
    stages {
        stage('Build Docker Image') {
            steps {
                // Build Docker image with a unique tag using the build number
                sh "docker build -t flask-demo:${BUILD_NUMBER} ."
            }
        }
        stage('Run Flask App') {
            steps {
                // Securely inject the DEMO_SECRET and run the container
                withCredentials([string(credentialsId: 'flask-demo-secret', variable: 'DEMO_SECRET')]) {
                    // Stop any existing containers created from the flask-demo image
                    sh '''
                      docker ps -q --filter "ancestor=flask-demo" | grep . && docker stop $(docker ps -q --filter "ancestor=flask-demo") || echo "No container to stop"
                    '''
                    // Run the new container with the secret as an environment variable
                    sh "docker run -d -e DEMO_SECRET=\${DEMO_SECRET} -p 7549:7549 flask-demo:${BUILD_NUMBER}"
                }
            }
        }
    }
}
