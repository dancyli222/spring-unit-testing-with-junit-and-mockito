pipeline {
    agent {
        docker {
            image 'maven:3-alpine'
            args '-v /root/.m2:/root/.m2'
        }
    }
    stages {
        stage('Build') {
            steps {
                sh 'mvn -B -DskipTests clean package'
            }
        }
        stage('Code Analysis with sonarQube') {
            steps {
                withSonarQubeEnv(credentialsId: '89aef6769e668fab1dc47af83bd2be021f31f88e', installationName: 'sonar')
                sh 'mvn org.sonarsource.scanner.maven:sonar-maven-plugin:3.7.0.1746:sonar'
            }
        }
        stage('Test') {
            steps {
                sh 'mvn org.jacoco:jacoco-maven-plugin:prepare-agent test'
            }
            post {
                always {
                    archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }
        stage('Built Docker Image') {
            steps {
                sh 'build -t my-image .'
            }
        }
    }
}