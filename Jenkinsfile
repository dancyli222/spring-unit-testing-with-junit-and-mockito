pipeline {
    agent any
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
                    junit '**target/surefire-reports/*.xml'
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
                    sh 'docker login -u ${your_docker_user} -p ${your_docker_password}'
                    sh 'docker push ${your_docker_user}/${docker_image_name}:latest'
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
    environment {
        GIT_PROJECT_ADDR='https://github.com/dancyli222/spring-unit-testing-with-junit-and-mockito.git'  //项目的git地址
        PROJECT_NAME='${JOB_NAME}'  //项目名称
        JAR_NAME='unit-testing-0.0.1-SNAPSHOT.jar' //项目打包成的jar文件名
        docker_image_name = 'unit-testing'  //docker镜像名称，一般和项目名相同
        your_docker_user = 'jli7512'  
        your_docker_password = 'Med68some'
        your_docker_host = "hub.docker.com"
  }
}