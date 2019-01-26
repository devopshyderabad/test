node {
    stage('Scm Checkout') {
            git (credentialsId: '97642376-57e4-413e-b87c-f54c8f03209a', url: 'https://github.com/devopshyderabad/test.git',branch: 'master')
    }
    stage('Build'){
          def mvnHome = tool name: 'maven3', type: 'maven'
	def mvnCMD = "${mvnHome}/bin/mvn"
	sh label: '', script: "${mvnCMD} clean package"
    }
    stage('SonarQube Analysis') {
        def mvnHome =  tool name: 'maven3', type: 'maven'
        withSonarQubeEnv('sonarqube') { 
          sh "${mvnHome}/bin/mvn sonar:sonar"
	}
    }
    stage('DockerBuild') {
      sh 'docker build -t devopshyderabad/myapp:1.0 .'
    }
     stage('DockerPush') {
     withCredentials([string(credentialsId: 'docker-pwd', variable: 'dockerpassword')]) {
     sh "docker login -u devopshyderabad -p ${dockerpassword}"
   }     
      sh 'docker push devopshyderabad/myapp:1.0'
    }
    stage('startcontainer') {
    def dockerRun = 'docker run --name nag -p 8081:8080 -d devopshyderabad/myapp:1.0 /bin/bash'
    sshagent(['8086962c-8a2f-49ee-8337-3fee15f16f28']) {
    sh "ssh -o StrictHostKeyChecking=no ec2-user@ec2-18-219-194-232.us-east-2.compute.amazonaws.com ${dockerRun}"
   }
    }
       stage('email notification') {
   mail bcc: '', body: '''Hi welcome jenkins build status

Thanks,
Nagendra''', cc: '', from: '', replyTo: '', subject: 'BUILD DETAILS', to: 'naga5856@gmail.com'
   }
}
