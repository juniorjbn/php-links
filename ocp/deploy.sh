#!/bin/bash

set -ex

PREFIX="app"

PROJECT=$(echo "$JENKINS_URL" | cut -d\. -f1 | cut -d\- -f2-)
DOMAIN=$(echo "$JENKINS_URL" | cut -d\. -f2,3 | rev | cut -c 2- | rev)

export GITHUB="https://github.com/juniorjbn/php-links.git"
export ENV=$PREFIX-$BRANCH_NAME
export IMAGE_TAG="docker-registry.default.svc:5000/$PROJECT/$ENV"
export HOSTNAME=$(tr -t '[A-Z]' '[a-z]' <<<$ENV-$PROJECT.$DOMAIN)

echo ">> Deploying ..."

# cat ocp/app.yml | envsubst | oc new-app -f - 

# oc start-build $ENV -F -w

sed "
  s|__HOSTNAME__|$HOSTNAME|;
  s|__ENV__|$ENV|;
  s|__IMAGE_TAG__|$IMAGE_TAG|;
  s|__GITHUB__|$GITHUB|;
  s|__BRANCH_NAME__|$BRANCH_NAME|;
  " -i ocp/app.yml 

oc new-app -f ocp/app.yml 

oc start-build $ENV

#wait time for build and deploy app
sleep 20

echo ">> Deployed to getup cluster - Just wait the build finish"
