#!/bin/bash

set -ex

ENV="$BRANCH_NAME"

echo ">> Deleting merged apps"
oc delete bc -l "app-$ENV"
oc delete dc -l "app-$ENV"
oc delete is -l "app-$ENV"
oc delete all -l "app=$ENV"
