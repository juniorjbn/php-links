#!/bin/bash

set -ex

PREFIX="app"

ENV="$PREFIX-$BRANCH_NAME"

echo ">> Deleting merged apps"
oc delete bc -l "app-$ENV"
oc delete dc -l "app-$ENV"
oc delete is -l "app-$ENV"
oc delete route -l "$HOSTNAME"
oc delete all -l "app=$ENV"
