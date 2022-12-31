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
        // stage("Compile") {
        //     steps {
        //         sh "./gradlew compileJava"
        //     }
        // }
        // stage("Unit test") {
        //     steps {
        //         sh "./gradlew test"
        //     }
        // }
        // stage("Code coverage") {
        //     steps {
        //         sh "./gradlew jacocoTestReport"
        //         publishHTML (target: [
        //             reportDir: 'build/reports/jacoco/test/html',
        //             reportFiles: 'index.html',
        //             reportName: "JaCoCo Report"
        //         ])
        //         sh "./gradlew jacocoTestCoverageVerification"
        //     }
        // }
        // stage("Static code analysis") {
        //     steps {
        //         sh "./gradlew checkstyleMain"
        //         publishHTML (target: [
        //             reportDir: 'build/reports/checkstyle/',
        //             reportFiles: 'main.html',
        //             reportName: "Checkstyle Report"
        //         ])
        //     }
        // }
        stage("Package") {
            steps {
                sh "./gradlew build"
            }
        }
        stage("Docker build") {
            steps {
                sh "docker build -t tmzls123/calculator ."
            }
        }
        stage("Docker push") {
            steps {
                sh "docker push tmzls123/calculator"
            }
        }
        stage("Deploy to staging") {
            steps {
                sh "docker run -d --rm -p 8765:8081 --name calculator tmzls123/calculator"
            }
        }
        stage("Acceptance test") {
            steps {
                sleep 60
                sh "chmod +x acceptance_test.sh && ./acceptance_test.sh"
            }
        }
    }
    post {
        always {
            sh "docker stop calculator"
        }
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