#!/bin/bash

set -ex

PREFIX="app"

PROJECT=$(echo "$JENKINS_URL" | cut -d\. -f1 | cut -d\- -f2-)
DOMAIN=$(echo "$JENKINS_URL" | cut -d\. -f2,3 | rev | cut -c 2- | rev)

export GITHUB="https://github.com/juniorjbn/php-links.git"
export ENV=$PREFIX-$BRANCH_NAME
export IMAGE_TAG="docker-registry.default.svc:5000/$PROJECT/$ENV"
export HOSTNAME=$ENV-$PROJECT.$DOMAIN

echo ">> Deploying ..."

# cat ocp/app.yml | envsubst | oc new-app -f - 

# oc start-build $ENV -F -w

sed "
  s|__HOSTNAME__|$HOSTNAME|;
  s|__ENV__|$ENV|;
  s|__IMAGE_TAG__|$IMAGE_TAG|;
  s|__GITHUB__|$GITHUB|;
  s|__BRANCH_NAME__|$BRANCH_NAME|;
  " -i ocp/app.yml ; cat app.yaml ; oc new-app -f ocp/app.yml ; oc start-build $ENV -F -w 

if [ $? != 0 ]; then
  exit 1
fi

echo ">> Deployed to getup cluster"
