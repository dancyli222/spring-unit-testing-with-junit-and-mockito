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
            steps {
                sh 'mvn -DskipTests -Ddocker.tag=latest dockerfile:build'
                script{
                    sh 'docker build -t myImage .'
                    sh 'docker login xxxxxx -uxx -pxx'
                    def image = docker.image(imageName)
                    image.push()
                    image.tag(imageTage)
                    image.push(imageTag)
                }
            }
        }
        stage('deploy dev'){
            steps{
                script{
                    sh 'docker run -itd --name myImage'
                }
            }
        }
    }
}