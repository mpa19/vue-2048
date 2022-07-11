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

        /*stage('Create instance AWS EC2'){
            steps{
                withAWS(credentials:'AWS-KEY',region:'eu-west-1') {
                    sh '''cd terraform/
                        terraform init
                        terraform apply -auto-approve'''                }
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
                        sh '''cd ansible/
                            ansible-playbook -i aws_ec2.yml ec2-provision.yml'''
                    }
                }
            }
        }*/

        stage('Minikube apply') {
            steps {
                withKubeCredentials(kubectlCredentials: [[caCertificate: '/home/sinensia/.minikube/ca.crt', clusterName: 'minikube', contextName: '', credentialsId: 'kubectl', namespace: 'minikube', serverUrl: 'https://192.168.49.2:8443']]) {
                    sh "kuberctl apply -f ./minikube/vue2048.yaml"
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
