pipeline {
    agent any
    parameters{
        string(name: 'docker_host', defaultValue: 'hub.docker.com')
        string(name: 'dockerUser', defaultValue:'jli7512')
        string(name: 'dockerPassword', defaultValue: 'Med68some')
        string(name: 'docker_image_name', defaultValue: 'myimage')
    }
    stages {
        //从代码仓库拉取代码
        stage('Pull code'){
            agent any
            steps{
                echo '1. fetch code from git'
            }
        }

        stage('Unit Test'){
            agent {
                docker {
                    image 'maven:3-alpine'
                    args '-v /root/.m2:/root/.m2'
                }
            }
            steps {
                echo '2. unit test'
                sh 'mvn -B org.jacoco:jacoco-maven-plugin:prepare-agent test'
                jacoco changeBuildStatus:true,maximumLineCoverage:"70"
            }
            post {
                always {
                    xunit([JUnit(deleteOutputFiles:true,failIfNotNew:true,pattern:'**target/surefire-reports/*.xml')])
                }
            }
        }
        //构建代码
        stage('Build'){
            agent {
                docker {
                    image 'maven:3-alpine'
                    args '-v /root/.m2:/root/.m2'
                }
            }
            steps {
                echo '4. make build'
                sh 'mvn -B -DskipTests clean package'
                archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
            }
        }
        stage('Build Docker Image') {
            agent any
            steps {
                script{
                    sh 'docker build -t ${docker_image_name} .'
                    sh 'docker login ${docker_host} -u ${dockerUser} -p ${dockerPassword}'
                    sh 'docker push ${docker_image_name}'
                }
            }
        }
        //部署到远程服务器
        stage('Deploy') {
            agent any
            steps {
                echo '7. pull docker image and run container'
            }                
        }
        //执行BVT测试
        stage('Build Verification Test') {
            agent any
            steps {                
                echo "8. Run Build Verification Test"
            }
        }
    }
}