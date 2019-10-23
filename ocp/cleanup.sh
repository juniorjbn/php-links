#!/bin/bash

set -ex

source ./ocp/values.txt

export APPBRANCH=$PREFIX-$BRANCH_NAME

#variable exported by Jenkins
ENV="$BRANCH_NAME"

echo ">> Deleting merged apps"
oc -n "$NAMESPACE" delete bc/$APPBRANCH dc/$APPBRANCH svc/$APPBRANCH route/$APPBRANCH is/$APPBRANCH 

