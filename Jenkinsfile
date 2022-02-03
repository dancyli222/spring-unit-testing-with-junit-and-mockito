pipeline {
    agent {
        docker {
            image 'maven:3-alpine'
            args '-v /root/.m2:/root/.m2'
        }
    }
    stages {
        stage('Build'){
            steps {
                sh 'mvn -B -DskipTests clean package'
            }
        }
        stage('Code analysis with SonarQube'){
            steps{
                withSonarQubeEnv('sonar'){
                    sh 'mvn clean compile sonar:sonar -Dsonar.projectKey=Myproject -Dsonar.host.url=http://127.0.0.1:9000 -Dsonar.login=dc255142fef90d37fe732f411cd5ae5702f2e3ff'
                }
            }
        }
        stage('Unit Test'){
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
        stage('Build Docker Image') {
            echo 'build docker image'
            }
        stage('deploy'){
            echo 'deploy application to target machine'
        }
    }
}