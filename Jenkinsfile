pipeline {
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
        always {
            discordSend description: "Discord Notifier",
            title: JOB_NAME,
            link: env.BUILD_URL,
            result: currentBuild.currentResult,
            webhookURL: "https://discord.com/api/webhooks/1058296726689165372/VOIdYMUS7e6st_uhO-loKFIDs7voskfKgsiG-ggfoBTRYBAedN4FJIMYnFTplWBYUVzH"
        }
    }
}