pipeline{
    agent any

    stages {
        stage('Build') {
            steps {
                sh "docker-compose build"
                sh "docker-compose up"
            }
        }



        stage('Publish'){
           steps {
                 sshagent(['github-shh']) {
                    sh 'git tag BUILD-1.0.${BUILD_NUMBER}'
                    sh 'git push --tags'
                }
            }
        }
    }
}
