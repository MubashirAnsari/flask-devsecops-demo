pipeline {
    agent any
    stages {
        stage('Build Docker Image') {
            steps {
                sh "docker build -t flask-demo:${BUILD_NUMBER} ."
            }
        }
        stage('Run Flask App') {
            steps {
                withCredentials([string(credentialsId: 'flask-demo-secret', variable: 'DEMO_SECRET')]) {
                    // Check if there are any running containers using the same image and stop them
                    sh '''
                      CONTAINER_ID=$(docker ps -q --filter "ancestor=flask-demo")
                      if [ ! -z "$CONTAINER_ID" ]; then
                        echo "Stopping existing container with ID $CONTAINER_ID"
                        docker stop $CONTAINER_ID
                      else
                        echo "No container to stop"
                      fi
                    '''
                    
                    // Run the new container
                    sh "docker run -d -e DEMO_SECRET=\${DEMO_SECRET} -p 7549:7549 flask-demo:${BUILD_NUMBER}"
                }
            }
        }
    }
}
