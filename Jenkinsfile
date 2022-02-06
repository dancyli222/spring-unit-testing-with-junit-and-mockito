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
                sh '''
                docker build -f Dockerfile -t ${IMAGE_NAME} .
                docker tag ${IMAGE_NAME} ${IMAGE_ADDR}:latest
                docker login -u ${DOCKER_ID} -p ${DOCKER_PASSWORD}
                docker push ${IMAGE_NAME}：${VERSION_ID}
                '''
            }
        }
        //部署到远程服务器
        stage('Deploy') {
            agent any
            steps {
                echo '7. pull docker image and run container'
                sh '''
                docker login -u ${DOCKER_ID} -p ${DOCKER_PASSWORD}
                docker pull ${IMAGE_NAME：${VERSION_ID}
                docker run --name ${PROJECT_NAME} -p 9001:50051 -d ${IMAGE_ADDR}:latest
                '''
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
        IMAGE_NAME = 'unit-testing'  //docker镜像名称，一般和项目名相同
        DOCKER_ID = 'jli7512'
        IMAGE_ADDR = "hub.docker.com/${DOCKER_ID}/${IMAGE_NAME}"
        DOCKER_PASSWORD = 'Med68some'
  }
}