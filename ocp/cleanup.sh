#!/bin/bash

set -ex

source ./ocp/values.txt

export APPBRANCH=$PREFIX-$BRANCH_NAME

#variable exported by Jenkins
ENV="$BRANCH_NAME"

echo ">> Deleting merged apps"
oc -n "$NAMESPACE" delete buildConfig -l app="$APPBRANCH"
oc -n "$NAMESPACE" delete deploymentConfig -l app="$APPBRANCH"
oc -n "$NAMESPACE" delete imageStream -l app="$APPBRANCH"
oc -n "$NAMESPACE" delete route -l app="$APPBRANCH"
oc -n "$NAMESPACE" delete all -l app="$APPBRANCH"

