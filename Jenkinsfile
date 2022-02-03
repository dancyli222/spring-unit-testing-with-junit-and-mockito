pipeline {
    agent {
        docker {
            image 'maven:3-alpine'
            args '-v /root/.m2:/root/.m2'
        }
    }
    stages {
        stage('Pull code'){
            steps{
                echo 'fetch code from git'
                git  credentialsId: 'github', url: 'https://github.com/dancyli222/spring-unit-testing-with-junit-and-mockito.git'
            }
        }
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
                script{
                    sh 'docker build -t myImage .'
                    sh 'docker login https://hub.docker.com/ -ujli7512 -pMed68some'
                    def image = docker.image(myImage)
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