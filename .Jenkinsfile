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
              sh "./qualiti-script.sh 7136a7636c6f7b70 dc466b9b6a79f51f41d18fb0c69c79fb"
          }
      }
  }
}
