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
        #静态代码扫描
        stage('Code analysis with SonarQube'){
            withSonarQubeEnv('sonar'){
                sh 'mvn verify sonar:sonar -Dsonar.projectKey=Myproject -Dsonar.host.url=http://localhost:9000 -Dsonar.login=dc255142fef90d37fe732f411cd5ae5702f2e3ff'
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