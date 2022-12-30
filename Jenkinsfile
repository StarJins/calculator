pipeline {
    environment {
        WEBHOOK_URL = credentials("DISCORD_WEB_HOOK_URL")
    }
    triggers {
        pollSCM('* * * * *')
    }
    agent {
        label 'java17'
    }
    stages {
        stage("Compile") {
            steps {
                sh "./gradlew compileJava"
            }
        }
        stage("Unit test") {
            steps {
                sh "./gradlew test"
            }
        }
        stage("Code coverage") {
            steps {
                sh "./gradlew jacocoTestReport"
                publishHTML (target: [
                    reportDir: 'build/reports/jacoco/test/html',
                    reportFiles: 'index.html',
                    reportName: "JaCoCo Report"
                ])
                sh "./gradlew jacocoTestCoverageVerification"
            }
        }
        stage("Static code analysis") {
            steps {
                sh "./gradlew checkstyleMain"
                publishHTML (target: [
                    reportDir: 'build/reports/checkstyle/',
                    reportFiles: 'main.html',
                    reportName: "Checkstyle Report"
                ])
            }
        }
    }
    post {
        success {
            discordSend description: "테스트 빌드가 성공했습니다",
            link: env.BUILD_URL, result: currentBuild.currentResult,
            webhookURL: env.WEBHOOK_URL
        }
        failure {
            discordSend description: "테스트 빌드가 실패했습니다",
            link: env.BUILD_URL, result: currentBuild.currentResult,
            webhookURL: env.WEBHOOK_URL
        }
    }
}