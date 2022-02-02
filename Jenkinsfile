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
        stage('Code Analysis with SonarQube') {
            steps{
                withSonarQubeEnv(credentialsId: '89aef6769e668fab1dc47af83bd2be021f31f88e', installationName: 'sonar'){
                    sh 'mvn sonar:sonar'
                }
            }
        }
        stage('Test') {
            steps {
                sh 'mvn -B org.jacoco:jacoco-maven-plugin:prepare-agent test'
                jacoco changeBuildStatus:true,maximumLineCoverage:"20"
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