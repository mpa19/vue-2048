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
                        recordIssues(tools: [trivy(id: 'trivyimage', pattern: 'resultsImage.json')])
                    },
                    b: {
                        sh "trivy fs --security-checks vuln,secret,config -f json -o resultsFs.json ./"
                        recordIssues(tools: [trivy(id: 'trivyfs', pattern: 'resultsFs.json')])
                    }
                )
            }
        }

        stage('Build') {
            steps {
                sh "docker-compose build"
            }
        }

        stage('Docker push') {
            steps {
                withCredentials([string(credentialsId: 'docker', variable: 'token')]) {
                    sh 'echo $token | docker login -u marcpz --password-stdin'
                    sh 'docker push marcpz/2048:latest'
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
