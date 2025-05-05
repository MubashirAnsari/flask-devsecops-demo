pipeline {
    agent any
    environment {
        FLASK_PORT = "7549"
    }
    stages {
        stage('Clean Existing Docker State') {
            steps {
                sh '''
                    echo "Checking for container using port ${FLASK_PORT}..."
                    USED_CONTAINER=$(docker ps --filter "publish=${FLASK_PORT}" -q)
                    if [ ! -z "$USED_CONTAINER" ]; then
                      echo "Stopping container on port ${FLASK_PORT}..."
                      docker stop $USED_CONTAINER
                      docker rm $USED_CONTAINER
                    else
                      echo "No container using port ${FLASK_PORT}"
                    fi

                    echo "Cleaning up old flask-demo containers..."
                    docker ps -a --filter "ancestor=flask-demo" -q | xargs -r docker rm -f

                    echo "Removing flask-demo image cache (if exists)..."
                    docker images -q flask-demo | xargs -r docker rmi -f || true
                '''
            }
        }

        stage('Build Docker Image (No Cache)') {
            steps {
                sh "docker build --no-cache -t flask-demo:${BUILD_NUMBER} ."
            }
        }

        stage('Run Flask App on Port 7549') {
            steps {
                withCredentials([string(credentialsId: 'flask-demo-secret', variable: 'DEMO_SECRET')]) {
                    sh '''
                        echo "Running new flask-demo container..."
                        docker run -d --rm \
                          -e DEMO_SECRET=${DEMO_SECRET} \
                          -p ${FLASK_PORT}:${FLASK_PORT} \
                          flask-demo:${BUILD_NUMBER}
                    '''
                }
            }
        }
    }
}
