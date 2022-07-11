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
                withKubeCredentials(kubectlCredentials: [[caCertificate: '''-----BEGIN CERTIFICATE-----
                MIIDBjCCAe6gAwIBAgIBATANBgkqhkiG9w0BAQsFADAVMRMwEQYDVQQDEwptaW5p
                a3ViZUNBMB4XDTIyMDcwNzEzMDczOFoXDTMyMDcwNTEzMDczOFowFTETMBEGA1UE
                AxMKbWluaWt1YmVDQTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAN/U
                JWyodamYSJHERcNkRh2oCJeh4JcDgZ0SltAGoY5ndcs7XM/KsF2uleaIDGRrrwZ0
                bBsA/9pSupIvfJhW+wR7JOI9cD7R82a9l1+3E1Rk5vZsAetFzz7IQxLpJi7Iw1L2
                F89MaW5Hm3hVsF1LRAlg81po5QUxjL94yKI4XEMPBftneRMj8F3evAlL7X0OmCQj
                +/UeP9do91RCHRxC10z3Pcvu4qk4my0oV9mAZxcIO1LU2hYpWcq+bj0vyxDUD7hi
                YdiaybcE6p9x7JZNu8sCQb2JjU+nbf6FYyrSb69scOHpADfGVH/SaidMm6vfiLOE
                b1HmRiBFLSnYlwJpq8ECAwEAAaNhMF8wDgYDVR0PAQH/BAQDAgKkMB0GA1UdJQQW
                MBQGCCsGAQUFBwMCBggrBgEFBQcDATAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQW
                BBSMcWAxdA/i8atw6OXSvlJoGExoATANBgkqhkiG9w0BAQsFAAOCAQEA23vxvdaW
                7AY3+zq2fITQJfvFAKZ14AVackk60aiIqnWdH57TNUe9wFOzmOsiBCSfQhLgPksC
                M7Gnh2gYtzwXwgFfRcMCMyGWDerNl481VuEmGyDhWhriIbCo1Ker4CUE75P5Rxby
                Wfk2IzZVbWEm6qeYWhu4mAX52zcxHtVqmykv4ydUQh86cWrWKzNx0w0reKadZU18
                c+5oVjIk5pjJFLSodNqWrEBAhLoMeuHPtUANo4eyV9mPBK91EXyr2ROVE1hmzVBY
                RxiWRgHYnT3JABcg7PDp5I14f0OiXn7iTfdRpJzjmDeAGf4ZiHtjGLdZHv6GTq2q
                D6ozWk8tfoIUag==
                -----END CERTIFICATE-----
                ''', clusterName: 'minikube', contextName: '', credentialsId: 'kubectl', namespace: 'minikube', serverUrl: 'https://192.168.49.2:8443']]) {
                    sh "kubectl apply -f ./minikube/vue2048.yaml"
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
