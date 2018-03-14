#!/bin/bash

set -ex

PREFIX="app"

ENV="$PREFIX-$BRANCH_NAME"

echo ">> Deleting merged apps"
oc delete buildConfig -l "app-$ENV"
oc delete deploymentConfig -l "app-$ENV"
oc delete imageStream -l "app-$ENV"
oc delete route -l "$HOSTNAME"
oc delete all -l "app=$ENV"
