pipeline {
    agent {
        docker {
            image 'maven:3-alpine'
            args '-v /root/.m2:/root/.m2'
        }
    }
    stages {
        stage('Prepare'){
            steps{
                echo "1. Prepare Stage"
                script{
                    dockerUser = "jli7512"
                    dockerPassword = "password"
                    img_name = "MyImage"
                    docker_image_name = "${dockerUser}/${img_name}"      
                }
            }
        }
        //从代码仓库拉取代码
        stage('Pull code'){
            steps{
                echo '2. fetch code from git'
            }
        }

        stage('Unit Test'){
            steps {
                echo '4. unit test'
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
            steps {
                echo '5. make build'
                sh 'mvn -B -DskipTests clean package'
                archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
            }
        }
        stage('Build Docker Image') {
            agent {
                docker {
                    image 'maven:3-alpine'
                    args '-v /root/.m2:/root/.m2'
                }
            }
            steps {
                sh '/usr/bin/docker build -t myImage .'
            }
        }
        //部署到远程服务器
        stage('Deploy') {
            steps {
                echo '7. pull docker image and run container'
            }                
        }
        //执行BVT测试
        stage('Build Verification Test') {
            steps {                
                echo "8. Run Build Verification Test"
            }
        }
    }
}