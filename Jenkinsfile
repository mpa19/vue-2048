node{
    agent any
    def app
    stages {
        stage('Build') {
            steps {
                script{
                  app = docker.build("my-apache2")
                }
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
