pipeline {
  agent {
    docker {
      image 'maven:3-alpine'
      args '-v /root/.m2:/root/.m2'
    }

  }
  stages {
    stage('Unit Test') {
      steps {
        sh '''sh \'mvn -B org.jacoco:jacoco-maven-plugin:prepare-agent test\'
jacoco changeBuildStatus:true,maximumLineCoverage:"70"'''
        jacoco(buildOverBuild: true)
        junit '**target/surefire-reports/*.xml'
      }
    }

    stage('Build') {
      steps {
        sh '''sh \'mvn -B -DskipTests clean package\'
'''
        archiveArtifacts(artifacts: 'target/*.jar', fingerprint: true)
      }
    }

    stage('Build Docker Image') {
      steps {
        sh '''sh \'docker build -t ${docker_image_name} .\'
sh \'docker push ${docker_image_name}:latest\''''
      }
    }

  }
  environment {
    docker_image_name = 'unittest'
    dockerUser = 'jli7512@163.com'
    dockerPassword = 'password'
  }
}