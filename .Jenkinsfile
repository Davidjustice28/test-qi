pipeline {
  agent any
  stages {
     stage('Checkout to the testing Repo') {
          steps {
             checkout scm
          }
      }
      stage('Run qualiti script') {
          steps {
              sh "chmod +x ./qualiti-script.sh"
              sh "./qualiti-script.sh <API-KEY> <CLIENT-ID>"
          }
      }
  }
}
