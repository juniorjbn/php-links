#!groovy

node {
    checkout()
    slackStartJob()

    /* feature branch */
    if  ( env.BRANCH_NAME != 'master' ) {
        branchCleanup()
        branchDeploy()
        allTests()
        userApproval()
        branchCleanup()
        msgbranchCleanup()
    }
 
    /* master branch dev-qa-prod */
    if  ( env.BRANCH_NAME == 'master' ) {
        SonarQubeAnalysis()
        allTests()
        masterDevDeploy()
        allTests()
        promoteQA()
        userApproval2()
        promotePROD()
        slackFinishedJob()
    }
}

/* ### def stages ### */

def checkout () {
	stage 'Checkout'
	deleteDir()
	checkout scm
}

def slackStartJob () {
    stage 'slackStartJob'
    sh 'git log -1 --pretty=%B > commit-log.txt'
    GIT_COMMIT=readFile('commit-log.txt').trim()
    slackSend channel: 'aristides', color: '#37d660', message: ":metal: - PROJECT - ${env.JOB_NAME} - Environment created and on the road! - (${GIT_COMMIT})"
}

def branchDeploy () {
	stage 'branchDeploy'
	sh "ocp/deploy.sh"
}

def branchCleanup () {
	stage 'branchCleanup'
    sh "ocp/cleanup.sh"
}

def msgbranchCleanup () {
    slackSend channel: 'aristides', color: '#f74545', message: ":thumbsup_all: - PROJECT - ${env.JOB_NAME} - (${GIT_COMMIT}) - Branch environment deleted!"
}

def masterDevDeploy () {
	stage 'masterDevDeploy'
	openshiftBuild(buildConfig: 'app-dev', showBuildLogs: 'true')
	openshiftVerifyDeployment(deploymentConfig: 'app-dev', verbose: 'true', waitTime: '10', waitUnit: 'min')
}

def SonarQubeAnalysis () {
    stage('SonarQube analysis') { 
      // requires SonarQube Scanner 2.8+
      def scannerHome = tool 'SonarQube Scanner 2.6.1';
      withSonarQubeEnv('SonarQubeScanner') {
      sh "${scannerHome}/bin/sonar-scanner"
      }  
    }
}

def allTests () {
	pipeline {
	  agent none
	  stages {
	    stage("Distributed Tests") {
	      steps {
	        parallel (
	          "Firefox" : {
	            node('master') {
	              sh "echo from Firefox"
	            }
	          },
	          "Chrome" : {
	            node('master') {
	              sh "echo from Chrome"
	            }
	          },
	          "IE6 : )" : {
	            node('master') {
	              sh "echo from IE6"
	            }
	          }
	        )
	      }
	    }
	  }
	}
}

def userApproval () {
	stage 'userApproval'
	timeout(time: 15, unit: 'MINUTES'){
	    try {
	    input message: 'Is this version ready ? In 15 Minutes this step will be processed automatically!', submitter: 'dev,admin'
		} catch (err) {
		    sh "ocp/cleanup.sh"
		    slackSend channel: 'aristides', color: '#1e602f', message: ":goberserk: - Pipeline Aborted"
		    error ("Aborted Here") 
		}
	}
}

def userApproval2 () {
	stage 'userApproval'
    try {
    input message: 'Is this version ready ?', submitter: 'admin'
	} catch (err) {
	    slackSend channel: 'aristides', color: '#1e602f', message: ":goberserk: - Pipeline Aborted"
	    error ("Aborted Here2") 
	}
}


def promoteQA () {
	stage 'promoteQA'
    openshiftTag(srcStream: "app-dev", srcTag: "latest", destStream: "app-dev", destTag: "qaready")
    openshiftDeploy(depCfg: 'app-qa', namespace: 'aristides', verbose: 'true', waitTime: '10', waitUnit: 'min')
    openshiftVerifyDeployment(deploymentConfig: 'app-qa')
}

def promotePROD () {
	stage 'promotePROD'
    openshiftTag(srcStream: "app-dev", srcTag: "latest", destStream: "app-dev", destTag: "prodready")
    openshiftDeploy(depCfg: 'app-prod', namespace: 'aristides', verbose: 'true', waitTime: '10', waitUnit: 'min')
    openshiftVerifyDeployment(deploymentConfig: 'app-prod')
}

def slackFinishedJob () {
   stage 'slackFinishedJob'
   sh 'git log -1 --pretty=%B > commit-log.txt'
   GIT_COMMIT=readFile('commit-log.txt').trim()
   slackSend channel: 'aristides', color: '#1e602f', message: ":rocket: - UPDATE approved to production: PROJECT - ${env.JOB_NAME} - Build Number - ${env.BUILD_NUMBER} - (${GIT_COMMIT})"
}