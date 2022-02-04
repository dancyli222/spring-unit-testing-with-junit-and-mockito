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
                    dockerPassword = "Med68some"
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
        //构建代码
        stage('Build'){
            steps {
                echo '5. make build'
                sh 'mvn -B -DskipTests clean package'
                archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
            }
        }
        stage('Build Docker Image') {
            steps {
                script{
                    sh 'docker build -t myImage .'
                }
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