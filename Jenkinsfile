pipeline {
   agent none
   stages {
      stage('Checkout and Build Image') {
         agent {
            node {
                  label 'agent-build'
                }
         }    
            environment {
		 tag = sh(returnStdout: true, script: "git rev-parse -short=10 HEAD | tail -n +2").trim()	      
             	  }    
	    steps {
		git branch: 'main', credentialsId: '22f03a2a-00ff-444d-9485-4103b9f9e44e', url: 'https://github.com/chaubvimip/demo1.git'
		sh "docker build -t project-soc:$tag ."
		}			
       }	  
      stage('Unit Test') {
         agent {
            node {
                  label 'agent-build'
                }
            }
	    environment {
		tag = sh(returnStdout: true, script: "git rev-parse -short=10 HEAD | tail -n +2").trim()	      
             	}
            steps {
               sh " docker run --entrypoint nginx project-soc:$tag -t"
          	 }
	    post {
		failure {
		     	echo 'This build has failed. See logs for details.'
			}
		success {
			echo 'Build succeeded.'
			}
		}
	}
      stage('Deploy to server') {
        agent {
            node {
                  label 'agent-build'
                }
            }
	     environment {
		tag = sh(returnStdout: true, script: "git rev-parse -short=10 HEAD | tail -n +2").trim()	      
             	    }
            steps {
		sh "sed -i s/tag/$tag/g docker-compose.yaml"
		sh "docker-compose up -d --build "
   
          }
      }	
   }
}
