pipeline {
    agent any
    stages {
        stage('Prepare') { 
            steps {
                echo 'Hello World ${env.BUILD_ID}'
                checkout scm
            }
        }
        stage('Build'){
            steps {
                script {
                    def customImage = docker.build("registry.silvenga.com/deluge:${env.BUILD_ID}")
                }
            }
        }
        
        // stage('Publish') {
        //     steps {
        //     }
        // }
    }
}