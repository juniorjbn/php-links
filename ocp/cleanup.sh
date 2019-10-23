#!/bin/bash

set -ex

source ./ocp/values.txt

export APPBRANCH=$PREFIX-$BRANCH_NAME

#variable exported by Jenkins
ENV="$BRANCH_NAME"

echo ">> Deleting merged apps"
oc -n "$NAMESPACE" delete buildConfig --field-selector metadata.name=="$APPBRANCH"
oc -n "$NAMESPACE" delete deploymentConfig --field-selector metadata.name=="$APPBRANCH"
oc -n "$NAMESPACE" delete imageStream --field-selector metadata.name=="$APPBRANCH"
oc -n "$NAMESPACE" delete route --field-selector metadata.name=="$APPBRANCH"
oc -n "$NAMESPACE" delete all --field-selector metadata.name=="$APPBRANCH"

