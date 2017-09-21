pipeline {
    agent any
    environment {
        VERSION = VersionNumber(versionNumberString: '1.${BUILDS_ALL_TIME, XX}')
    }
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
                        def image = docker.build("registry.silvenga.com/deluge:${env.VERSION}")
                        image.push()
                        image.push("latest")
                    }
                }
            }
        }
    }
}