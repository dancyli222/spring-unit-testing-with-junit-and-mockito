pipeline {
    
    agent any
    stages {
        //从代码仓库拉取代码和用于流水线任务的jenkinsfile和Dockerfile
        stage('Pull code'){
            agent any
            steps{
                echo '1. fetch code from git'
                checkout scm
            }
        }
        stage('Unit Test'){
            agent {
                docker {
                    image 'maven:3-alpine'  //在流水线中启动maven
                    args '-v /root/.m2:/root/.m2'
                }
            }
            steps {
                echo '2. run unit test'
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
                echo '5. Build Docker Image and then push to docker server'
                sh '''
                docker build -f Dockerfile -t ${DOCKER_ID}/${IMAGE_NAME}:latest .
                docker login -u ${DOCKER_ID} -p ${DOCKER_PASSWORD}
                docker push ${DOCKER_ID}/${IMAGE_NAME}:latest
                '''
            }
        }
        //部署到远程服务器
        stage('Deploy') {
            agent any
            steps {
                echo '6. pull docker image and run container in test environment'
                sh '''
                docker login -u ${DOCKER_ID} -p ${DOCKER_PASSWORD}
                docker pull ${DOCKER_ID}/${IMAGE_NAME}:latest
                docker run --name ${IMAGE_NAME} -p 9001:9001 -d ${DOCKER_ID}/${IMAGE_NAME}:latest
                '''
            }                
        }
        //执行BVT测试
        stage('Build Verification Test') {
            agent any
            steps {                
                echo "7. Run Build Verification Test in test environment"
            }
        }
    }
    environment {
        GIT_PROJECT_ADDR='https://github.com/dancyli222/spring-unit-testing-with-junit-and-mockito.git'  //项目的git地址
        PROJECT_NAME='${JOB_NAME}'  //项目名称
        IMAGE_NAME = 'unit-testing'  //docker镜像名称，一般和项目名相同
        DOCKER_ID = 'jli7512'
        DOCKER_PASSWORD = 'Med68some'
  }
}