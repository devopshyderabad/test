node {
    stage('checkout') {
         git credentialsId: '4b60d533-8ed2-4083-b893-9e1304b183ee', url: 'https://github.com/devopshyderabad/test.git',branch: 'master'
    }
 stage('Build'){
          def mvnHome = tool name: 'maven3', type: 'maven'
	def mvnCMD = "${mvnHome}/bin/mvn"
	sh label: '', script: "${mvnCMD} clean package"
    }
 stage('Analysis') {
        def mvnHome =  tool name: 'maven3', type: 'maven'
        withSonarQubeEnv('sonarqube') { 
          sh "${mvnHome}/bin/mvn sonar:sonar"
	}
    }
  stage('copysource files') {
    sh label: '', script: 'cp -r /tmp/jdk-8u191-linux-x64.tar.gz "${WORKSPACE}"'
    sh label: '', script: 'cp -r /tmp/apache-tomcat-8.5.37.tar.gz "${WORKSPACE}"'
      }
   stage('Create Image') {
      sh 'docker build -t devopshyderabad/custom:1.0 .'
    }
    stage('DockerPush') {
     withCredentials([string(credentialsId: 'docker-pwd', variable: 'dockerpassword')]) {
     sh "docker login -u devopshyderabad -p ${dockerpassword}"
   }     
      sh 'docker push devopshyderabad/custom:1.0'
    }
    stage('startcontainer') {
    def dockerRun = 'docker run --name nag -p 8085:8080 -d devopshyderabad/custom:1.0'
    sshagent(['8086962c-8a2f-49ee-8337-3fee15f16f28']) {
    sh "ssh -o StrictHostKeyChecking=no ec2-user@ec2-18-219-194-232.us-east-2.compute.amazonaws.com ${dockerRun}"
   }
    }
 }
