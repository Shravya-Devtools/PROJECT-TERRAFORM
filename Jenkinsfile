pipeline {
  agent any
  environment {
    AWS_REGION = 'us-west-2'                         // Replace with your AWS region
    TF_VAR_aws_region = "${AWS_REGION}"
  }
  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }
    stage('Terraform Apply') {
      steps {
        withCredentials([[
          $class: 'AmazonWebServicesCredentialsBinding',
          credentialsId: 'aws-credentials'           // Your Jenkins AWS credentials ID
        ]]) {
          dir('infra') {
            sh '''
              terraform init
              terraform apply -auto-approve
            '''
          }
        }
      }
    }
    stage('Build JAR') {
      steps {
        dir('app') {
          sh './gradlew clean build'
        }
      }
    }
    stage('Upload to JFrog') {
      steps {
        withCredentials([usernamePassword(
          credentialsId: 'jfrog-creds',              // Jenkins JFrog credential ID
          usernameVariable: 'USER',
          passwordVariable: 'PASS'
        )]) {
          sh '''
            curl -u $USER:$PASS -T app/build/libs/app.jar \
            "https://<your-jfrog-domain>.jfrog.io/artifactory/libs-release-local/app.jar"  // Replace domain
          '''
        }
      }
    }
    stage('Upload to S3 (Optional)') {
      steps {
        withCredentials([[
          $class: 'AmazonWebServicesCredentialsBinding',
          credentialsId: 'aws-credentials'
        ]]) {
          sh '''
            aws s3 cp app/build/libs/app.jar s3://my-artifact-bucket/app.jar   // Replace bucket
          '''
        }
      }
    }
  }
}
