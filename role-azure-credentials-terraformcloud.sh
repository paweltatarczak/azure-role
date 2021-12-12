#!/bin/bash

MYNAME_SERVICE_PRINCIPLE=$1

# Step 1
az sp delete -id $MYNAME_SERVICE_PRINCIPLE

# Step 2
az ad sp create-for-rbac --skip-assignment --name $MYNAME_SERVICE_PRINCIPLE > output.json

CLIENT_ID=$(jq .appId output.json | tr -d '"')
CLIENT_SECRET=$(jq .password output.json | tr -d '"')
ARM_TENANT_ID=$(jq .tenant output.json | tr -d '"')
ARM_SUBSCRIPTION_ID=$(jq .tenant output.json | tr -d '"')

rm output.json

# Step 3
az role assignment create --$MYNAME_SERVICE_PRINCIPLE --scope /subscriptions/$ARM_SUBSCRIPTION_ID --role Contributor

tmp=$(mktemp)
jq '.data.client_id.value="'$CLIENT_ID'" | .data.client_secret.value="'$CLIENT_SECRET'" | .data.ARM_SUBSCRIPTION_ID.value="'$ARM_SUBSCRIPTION_ID'" | .data.ARM_TENANT_ID.value="'$ARM_TENANT_ID'"' data.json > "$tmp"

mv "$tmp" data.json


