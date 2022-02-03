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
                archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
            }
        }
        stage('Code analysis with SonarQube'){
            steps{
                echo 'code analysis with SonarQube'
                }
            }
        stage('Unit Test'){
            steps {
                sh 'mvn -B org.jacoco:jacoco-maven-plugin:prepare-agent test'
                jacoco changeBuildStatus:true,maximumLineCoverage:"20"
            }
            post {
                always {
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }
        stage('Build Docker Image') {
            steps{
                echo 'build docker image'
            }
        }

        //部署到远程服务器
        stage('deploy') {
            node('slav001'){
                steps {
                    echo 'deploy application to target machine'
                }                
            }
        }
        //执行BVT测试
        stage('Build Verification Test') {
            steps {                
                echo "Run Build Verification Test"
            }
        }
    }
}