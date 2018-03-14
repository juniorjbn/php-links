#!groovy

node {
	checkout()
	slackStartJob()

	/* feature branch */
	if ( env.BRANCH_NAME != 'master' ) {
		branchCleanup()
		branchDeploy()
		allTests()
		userApproval()
		branchCleanup()
		msgbranchCleanup()
    }
 
	/* master branch dev-qa-prod */
	if ( env.BRANCH_NAME == 'master' ) {
		masterDevDeploy()
		SonarQubeAnalysis()
		allTests()
		promoteQA()
		userApproval3()
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
    	slackSend channel: 'aristides', color: '#37d660', message: ":metal: - PROJECT - ${env.JOB_NAME} - BUILD - ${env.BUILD_NUMBER} - (${GIT_COMMIT}) - Pipeline Started! "
}

def branchDeploy () {
	stage 'branchDeploy'
	sh "ocp/deploy.sh"
	openshiftVerifyDeployment(deploymentConfig: "app-${env.BRANCH_NAME}")
}

def branchCleanup () {
	stage 'branchCleanup'
 	sh "ocp/cleanup.sh"
}

def msgbranchCleanup () {
    	slackSend channel: 'aristides', color: '#f74545', message: ":thumbsup_all: - PROJECT - ${env.JOB_NAME} - BUILD - ${env.BUILD_NUMBER} - (${GIT_COMMIT}) - Branch environment deleted!"
}

def masterDevDeploy () {
	stage 'masterDevDeploy'
	openshiftBuild(buildConfig: 'app-dev')
}

def SonarQubeAnalysis () {
   	stage('SonarQube analysis') { 
      		def scannerHome = tool 'SonarQubeScanner';
      		withSonarQubeEnv('SonarQubeScanner') {
	      		sh "${scannerHome}/bin/sonar-scanner"
	      		sh "sleep 10"
		}
		
      		def qualitygate = waitForQualityGate();
      		if (qualitygate.status != "OK") {
        		error "Pipeline aborted due to quality gate coverage failure: ${qualitygate.status}"
      		}
	}
}

def allTests () {
	parallel (
		"phpunit" : {
			node('master') {
	  			sh "oc exec `oc get pods -l app=app-dev | grep -i running | awk 'END { print $1 }'` ./vendor/bin/phpunit"
			}
		},
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
		"IE6" : {
			node('master') {
				sh "echo from IE6"
			}
		}
	)
}

def userApproval () {
	stage 'userApproval'
	slackSend channel: 'aristides', color: '#3399ff', message: ":point_up_2::skin-tone-2: - DEV - Please check out your app at : - http://app-${env.BRANCH_NAME}-aristides.getup.io/ "
	timeout(time: 5, unit: 'MINUTES'){
		try {
			input message: 'Is this version ready ? In 5 Minutes this step will be processed automatically!', id: 'input1', submitter: 'dev,admin'
		} catch (err) {
			sh "ocp/cleanup.sh"
			slackSend channel: 'aristides', color: '#1e602f', message: ":wave: - Environmet auto deleted - ${env.JOB_NAME}"
			error ("Aborted Here") 
		}
	}
}

def userApproval2 () {
	stage 'userApproval'
	slackSend channel: 'aristides', color: '#42e2f4', message: ":dusty_stick: - CTO - Please evaluate the Project - ${env.JOB_NAME} - http://jenkins-aristides.getup.io/blue/organizations/jenkins/aristides/detail/master/${env.BUILD_NUMBER}/pipeline/ "
	try {
		input message: 'Is this version ready ?', id: 'input1', submitter: 'admin'
	} catch (err) {
		slackSend channel: 'aristides', color: '#1e602f', message: ":goberserk: - Pipeline Aborted"
		error ("Aborted Here2") 
	}
}

def userApproval3 () {
	stage 'userApproval'
	try {
		sh './slack-hook.sh'
		input message: 'Is this version ready ?', id: 'input1', submitter: 'admin'
	} catch (err) {
		slackSend channel: 'aristides', color: '#1e602f', message: ":goberserk: - Pipeline Aborted"
		error ("Aborted Here2") 
	}
}

def promoteQA () {
	stage 'promoteQA'
	openshiftTag(srcStream: "app-dev", srcTag: "latest", destStream: "app-dev", destTag: "qaready")
	openshiftDeploy(depCfg: 'app-qa', namespace: 'aristides', verbose: 'false', waitTime: '10', waitUnit: 'min')
}

def promotePROD () {
	stage 'promotePROD'
	openshiftTag(srcStream: "app-dev", srcTag: "latest", destStream: "app-dev", destTag: "prodready")
	openshiftDeploy(depCfg: 'app-prod', namespace: 'aristides', verbose: 'false', waitTime: '10', waitUnit: 'min')
}

def slackFinishedJob () {
	stage 'slackFinishedJob'
	sh 'git log -1 --pretty=%B > commit-log.txt'
	GIT_COMMIT=readFile('commit-log.txt').trim()
	slackSend channel: 'aristides', color: '#1e602f', message: ":rocket: - PROJECT - ${env.JOB_NAME} - BUILD - ${env.BUILD_NUMBER} - (${GIT_COMMIT}) - Now running in PROD!"
}
