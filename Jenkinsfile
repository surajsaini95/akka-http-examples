pipeline {
    agent none
    environment {
        CI = 'true' 
    }
    options {
      timeout(time: 45, unit: 'MINUTES')
    }
    triggers {
      pollSCM 'H/5 * * * *'
    }

    stages {
        stage ('Parallel-Installation') {
            parallel {
              stage ('installation on ubuntu_aws') {
                agent {
                  label 'ubuntu_aws'
                }
                steps {
                  tool name: 'sbt', type: 'org.jvnet.hudson.plugins.SbtPluginBuilder$SbtInstallation'
                }
              }
              stage ('installation on ubuntu-gcp') {
                agent {
                  label 'ubuntu-gcp'
                }
                steps {
                  tool name: 'sbt', type: 'org.jvnet.hudson.plugins.SbtPluginBuilder$SbtInstallation'
                }
              }
            }
        }
        stage('Parallel-Compile'){
            when {
                branch 'dev'
            }
            failFast true
            parallel {
                stage ('Compile in aws') {
                    agent {
                        label "ubuntu_aws"
                    }
                    steps {
                        sh 'sbt clean compile'
                        echo "Compiled on ubuntu_aws"
                    }
                }
                stage ('Compile in gcp') {
                    agent {
                        label "ubuntu-gcp"
                    }
                    steps {
                        sh 'sbt clean compile'
                        echo "Compiled on ubuntu-gcp"
                    }
                }
            }
        }
        stage('Parallel-Test'){
            when {
                branch 'beta'
            }
            failFast true
            parallel {
                stage ('Test in aws') {
                    agent {
                        label "ubuntu_aws"
                    }
                    steps {
                        sh 'sbt test'
                        echo "Tested on ubuntu_aws"
                    }
                }
                stage ('Test in gcp') {
                    agent {
                        label "ubuntu-gcp"
                    }
                    steps {
                        sh 'sbt test'
                        echo "Tested on ubuntu-gcp"
                    }
                }
            }
        }
        
        stage('Build') {
            when {
                branch 'master'
            }
            agent {
                label "ubuntu-gcp"
            }
            steps {
                sh 'sbt assembly'
            }
        }
        stage ('deployment') {
            when {
                branch 'master'
            }
            agent {
                label "ubuntu_gcp"
            }
            steps {
                mail to: 'suraj.saini@knoldus.com',
                      subject: "Job '${JOB_NAME}' (${BUILD_NUMBER}) is waiting for input",
                      body: "Please go to ${BUILD_URL} and verify the deployment"
                input 'Proceed to Deploy'
                timeout(time: 10, unit: 'MINUTES') {
                    retry(5) {
                        sh './deploy.sh'
                    }
                }
            }
        }
    }
    post {
        always {
            mail to: 'suraj.saini@knoldus.com',
                 subject: "Pipeline: ${currentBuild.fullDisplayName} is ${currentBuild.currentResult}",
                 body: "Hey this is body of mail"
        }
        success {
            cleanWs()
        }
    }
}
