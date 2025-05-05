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
                    // Stop and remove any existing container using the flask-demo image
                    sh '''
                      CONTAINER_ID=$(docker ps -q --filter "ancestor=flask-demo")
                      if [ ! -z "$CONTAINER_ID" ]; then
                        echo "Stopping existing container with ID $CONTAINER_ID"
                        docker stop $CONTAINER_ID
                        docker rm $CONTAINER_ID
                      else
                        echo "No container to stop"
                      fi
                    '''

                    // Check if the port 7549 is in use and free it up
                    sh '''
                      if lsof -i :7549; then
                        echo "Port 7549 is in use, killing the process"
                        lsof -i :7549 -t | xargs kill -9
                      else
                        echo "Port 7549 is free"
                      fi
                    '''

                    // Run the container with port 7549
                    sh "docker run -d -e DEMO_SECRET=\${DEMO_SECRET} -p 7549:7549 flask-demo:${BUILD_NUMBER}"
                    echo "Flask app is running on port 7549"
                }
            }
        }
    }
}
