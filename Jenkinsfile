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
                sh "trivy fs --security-checks vuln,secret,config -f json -o results.json ./"
                recordIssues(tools: [trivy(pattern: 'results.json')])
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
