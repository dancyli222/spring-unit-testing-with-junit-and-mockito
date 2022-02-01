pipeline {
    agent {
        docker {
            image 'maven:3-alpine'
            args '-v /root/.m2:/root/.m2'
        }
    }
    stages {
        stage('init') {
           steps {
            script{
              def dockerPath = tool 'docker' //全局配置里的docker
              env.PATH = "${dockerPath}/bin:${env.PATH}" //添加了系统环境变量上
            }
        }
    }
        stage('Build') {
            steps {
                sh 'mvn -B -DskipTests clean package'
            }
        }
        stage('Test') {
            steps {
                sh 'mvn test'
            }
            post {
                always {
                    archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }
        stage('Docker-build') {
            steps {
                echo "build docker image and push to docker repository"
                sh 'docker build -t  my-image .'
            }
        }
    }
}