pipeline{
    agent any
    options {
            ansiColor('xterm')
            timestamps ()
            disableConcurrentBuilds()
            buildDiscarder(logRotator(numToKeepStr: '5'))
    }

    stages {

        stage('Build') {
            steps {
                sh "docker-compose build"
            }
        }

        stage('Trivy') {
            steps {
                sh "trivy image -f json -o results.json my-apache2"
                recordIssues(tools: [trivy(pattern: 'results.json')])
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
