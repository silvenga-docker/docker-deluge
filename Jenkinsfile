pipeline {
    agent any
    stages {
        stage('Prepare') { 
            steps {
                checkout scm
            }
        }
        stage('Build'){
            steps {
                script {
                    docker.withRegistry("https://registry.silvenga.com", "registry") {
                        def image = docker.build("registry.silvenga.com/deluge:${env.BUILD_ID}")
                        image.push()
                        image.push("latest")
                    }
                }
            }
        }
    }
}