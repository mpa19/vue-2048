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

        stage('Deploy AWS EC2'){
            steps{
                withAWS(credentials:'AWS-KEY',region:'eu-west-1') {
                    sshagent(['SSH-AWS']) {
                        sh 'ansible-playbook -i inventory ec2-docker.yaml'
                    }
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
