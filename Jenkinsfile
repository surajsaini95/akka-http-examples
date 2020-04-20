pipeline {
    agent any
    environment {
        CI = 'true' 
    }
    option {
      timeout(time: 15, unit: 'MINUTES')
    }
    tools {
        sbt 'sbt'
    }
    triggers {
      pollSCM 'H/5 * * * *'
    }

    stages {
        stage('Compile') {
          steps {
            sh 'sbt clean compile'
          }
        }
        stage('Test') {
          steps {
            sh 'sbt test'
          }
        }
        stage('Build') {
          steps {
            sh 'sbt assembly'
          }
        }
        stage('Deploy') {
            steps {
                mail to: 'suraj.saini@knoldus.com',
                      subject: "Job '${JOB_NAME}' (${BUILD_NUMBER}) is waiting for input",
                      body: "Please go to ${BUILD_URL} and verify the deployment"
                input 'Proceed to Deploy'
                timeout(time: 5, unit: 'MINUTES') {
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
    }
}