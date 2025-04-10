pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                // Simulate build step
                echo 'Building...'
                // error 'Simulate failure' // Uncomment to test failure
            }
        }
    }
    post {
        success {
            emailext (
                subject: 'SUCCESS: Job ${env.JOB_NAME} Build #${env.BUILD_NUMBER}',
                body: 'Good news! The build succeeded.\nCheck console: ${env.BUILD_URL}',
                to: 'team@example.com'
            )
        }
        failure {
            emailext (
                subject: 'FAILURE: Job ${env.JOB_NAME} Build #${env.BUILD_NUMBER}',
                body: 'Something went wrong.\nCheck logs: ${env.BUILD_URL}',
                to: 'team@example.com'
            )
        }
    }
}
