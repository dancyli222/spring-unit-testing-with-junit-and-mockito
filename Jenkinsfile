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
        //执行单元测试及代码覆盖率分析，单元覆盖率要求为70%，如果低于70%则构建失败
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
        //创建docker镜像并推送到Docker服务器
        stage('Build Docker Image') {
            agent any
            steps {
                echo '5. Build Docker Image and then push to docker server'
                sh '''
                docker build -f pipeline/Dockerfile -t ${DOCKER_ID}/${IMAGE_NAME}:latest .
                docker login -u ${DOCKER_ID} -p ${DOCKER_PASSWORD}
                docker push ${DOCKER_ID}/${IMAGE_NAME}:latest
                '''
            }
        }
        //在测试服务器的节点拉取镜像，创建并启动容器
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
        //在测试服务器节点执行BVT测试
        stage('Build Verification Test') {
            agent any
            steps {                
                echo "7. Run Build Verification Test in test environment"
                sh '''
                docker pull postman/newman
                docker run --rm --name newman -t postman/newman run Sample-Collection.postman_collection.json 
                '''
            }
        }
    }
    environment {
        GIT_PROJECT_ADDR='https://github.com/dancyli222/spring-unit-testing-with-junit-and-mockito.git'  //项目的git地址
        PROJECT_NAME='${JOB_NAME}'  //项目名称
        IMAGE_NAME = 'unit-testing'  //docker镜像名称，一般和项目名相同
        DOCKER_ID = 'jli7512'
        DOCKER_PASSWORD = 'Med68some'
        TEST_SCRIPT = 'Sample-Collection.postman_collection.json'
    }
}