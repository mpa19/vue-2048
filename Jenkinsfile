pipeline{
    agent any

    stages {
        stage('Build') {
            steps {
                yarn 'install'
                yarn 'build'
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
