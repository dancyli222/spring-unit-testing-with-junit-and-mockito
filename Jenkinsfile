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
        stage('Code analysis with SonarQube'){
            steps{
                coverage('maven'){
                    withSonarQubeEnv('sonar'){
                        sh 'mvn -f pom.xml clean compile sonar:sonar'
                    }
                }
            }
            stage('mvn构建'){
                steps{
                    container('maven'){
                        sh ' mvn clean package -U -Dmaven.test.skip=true'
                    }
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