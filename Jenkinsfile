def emailRecipients = 'cmvishnubabu08@gmail.com'
// For multiple recipients: def emailRecipients = 'xyz@ecos.com,abc@vishalk17.com'

pipeline {
    agent {
        label 'master'
    }

    parameters {
        choice(name: 'IS_BUILD_NEEDED', choices: ['y', 'n'], description: 'Do you want to build the image?')
    }

    environment {
        docker_image_name = 'vishnu1/nginx'
        docker_image_tag = 'v2.0'
        DOCKERHUB_CREDENTIALS = credentials('docker-credential')
        JENKINS_URL = "${env.JENKINS_URL}"
        BUILD_URL = "${env.BUILD_URL}"
        CONSOLE_URL = "${BUILD_URL}console"
        JOB_NAME = "${env.JOB_NAME}"
        BUILD_NUMBER = "${env.BUILD_NUMBER}"
        is_build_needed = "${params.IS_BUILD_NEEDED}"
        BLUE_OCEAN_URL = "${JENKINS_URL}blue/organizations/jenkins/${JOB_NAME}/detail/${JOB_NAME}/${BUILD_NUMBER}/pipeline"
    }

    stages {
        stage('Start Notification') {
            steps {
                script {
                    currentBuild.result = 'SUCCESS'
                    emailext subject: "Job Started: ${JOB_NAME} #${BUILD_NUMBER}",
                        mimeType: 'text/html',
                        body: """
                        The job has started.<br>
                        <a href='${BUILD_URL}'>Click here</a> to view the job in Jenkins.<br>
                        <a href='${CONSOLE_URL}'>Click here</a> to view the console output.<br>
                        <a href='${BLUE_OCEAN_URL}'>Click here</a> to view the Blue Ocean pipeline.
                        """,
                        to: emailRecipients
                }
            }
        }

        stage('Global Condition') {
            when {
                expression { is_build_needed == 'n' }
            }
            steps {
                script {
                    currentBuild.result = 'SUCCESS'
                    error("Skipping all stages as is_build_needed is 'n'")
                }
            }
        }

        stage('Build image') {
            steps {
                sh 'pwd && whoami'
                sh 'git log --oneline -n 10'
                sh "docker build -t ${docker_image_name}:${docker_image_tag} ."
            }
        }

        stage('Login to Docker') {
            steps {
                sh "echo \$DOCKERHUB_CREDENTIALS_PSW | docker login -u \$DOCKERHUB_CREDENTIALS_USR --password-stdin"
            }
        }

        stage('Push docker image to Docker Hub') {
            steps {
                sh "docker push ${docker_image_name}:${docker_image_tag}"
            }
        }
    }

    post {
        success {
            script {
                currentBuild.result = 'SUCCESS'
            }
            emailext subject: "Job Succeeded: ${JOB_NAME} #${BUILD_NUMBER}",
                mimeType: 'text/html',
                body: """
                The job has succeeded.<br>
                <a href='${BUILD_URL}'>Click here</a> to view the job in Jenkins.<br>
                <a href='${CONSOLE_URL}'>Click here</a> to view the console output.<br>
                <a href='${BLUE_OCEAN_URL}'>Click here</a> to view the Blue Ocean pipeline.
                """,
                to: emailRecipients
        }

        failure {
            script {
                currentBuild.result = 'FAILURE'
            }
            emailext subject: "Job Failed: ${JOB_NAME} #${BUILD_NUMBER}",
                mimeType: 'text/html',
                body: """
                The job has failed.<br>
                <a href='${BUILD_URL}'>Click here</a> to view the job in Jenkins.<br>
                <a href='${CONSOLE_URL}'>Click here</a> to view the console output.<br>
                <a href='${BLUE_OCEAN_URL}'>Click here</a> to view the Blue Ocean pipeline.
                """,
                to: emailRecipients
        }

        always {
            sh 'docker logout'
        }
    }
}
