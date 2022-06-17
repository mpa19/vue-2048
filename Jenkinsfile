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
                        steps{
                            sh "trivy image -f json -o resultsImage.json my-apache2"
                            recordIssues(tools: [trivy(pattern: 'resultsImage.json')])
                        }
                    },
                    b: {
                        steps {
                            sh "trivy fs --security-checks vuln,secret,config -f json -o resultsFs.json ./"
                            recordIssues(tools: [trivy(pattern: 'resultsFs.json')])
                        }
                        
                    }
                )
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
