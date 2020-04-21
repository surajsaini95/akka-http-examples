pipeline {
    agent none
    environment {
        CI = 'true'
        SBT='/home/knoldus/jenkins-slave/tools/org.jvnet.hudson.plugins.SbtPluginBuilder_SbtInstallation/sbt/bin/sbt' 
    }
    options {
      timeout(time: 45, unit: 'MINUTES')
    }
    triggers {
      pollSCM 'H/5 * * * *'
    }

    stages {
        stage ('Parallel-Installation') {
             failFast true
             parallel {
              stage ('installation on ubuntu_gcp') {
                agent {
                  label 'ubuntu_gcp'
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
                stage ('Compile in ubuntu_gcp') {
                    agent {
                        label "ubuntu_gcp"
                    }
                    steps {
                        sh '$SBT clean compile'
                        echo "Compiled on ubuntu_gcp"
                    }
                }
                stage ('Compile in ubuntu-gcp') {
                    agent {
                        label "ubuntu-gcp"
                    }
                    steps {
                        sh '$SBT clean compile'
                        echo "Compiled on ubuntu-gcp"
                    }
                }
            }
        }
        stage('Parallel-Test'){
            when {
                branch 'beta'
            }
            parallel {
                stage ('Test in ubuntu_gcp') {
                    agent {
                        label "ubuntu_gcp"
                    }
                    steps {
                        sh '$SBT test'
                        echo "Tested on ubuntu_gcp"
                    }
                }
                stage ('Test in ubuntu-gcp') {
                    agent {
                        label "ubuntu-gcp"
                    }
                    steps {
                        sh '$SBT test'
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
                sh '$SBT assembly'
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
