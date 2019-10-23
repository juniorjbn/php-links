#!/bin/bash

set -ex

source ./ocp/values.txt

export APPBRANCH=$PREFIX-$BRANCH_NAME

echo ">> Deploying new branch ..."

oc -n $NAMESPACE get --export bc/$DEV_APP_NAME dc/$DEV_APP_NAME svc/$DEV_APP_NAME route/$DEV_APP_NAME -o yaml | \
 sed -e "s/$DEV_APP_NAME/$APPBRANCH/" -e "s/ref: master/ref: $BRANCH_NAME/" | \
 oc -n $NAMESPACE apply -f -

#Estou criando apenas o imagestream "por fora" pois ele tem um padrão e é bem simples e não é alterado com a interação no dia a dia
sed "
  s|__APPBRANCH__|$APPBRANCH|;
  s|__NAMESPACE__|$NAMESPACE|;
  " ocp/is_template.yaml | \
oc -n $NAMESPACE create -f -

oc -n $NAMESPACE start-build $APPBRANCH --follow --wait

echo ">> Deployed to cluster - Just wait the build finish"
 
