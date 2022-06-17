pipeline{
    agent any
    options {
            ansiColor('xterm')
            timestamps ()
            disableConcurrentBuilds()
            buildDiscarder(logRotator(numToKeepStr: '5'))
    }

    stages {

        stage('Trivy') {
            steps {
                parallel(
                    a: {
                        sh "trivy image -f json -o resultsImage.json my-apache2"
                    },
                    b: {
                        sh "trivy fs --security-checks vuln,secret,config -f json -o resultsFs.json ./"
                    }
                )
            }
            post {
                always {
                    recordIssues(tools: [trivy(pattern: 'resultsImage.json')])
                    recordIssues(tools: [trivy(pattern: 'resultsFs.json')])                        
                }
            }
        }

        stage('Build') {
            steps {
                sh "docker-compose build"
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
