#!/bin/sh

if [ -z "$1" ]
then
    echo "Key file required as first arg"
    exit 1
fi

if [ ! -f "$1" ]
then
    echo "$1 not found"
    exit 1
else
    KEY="$1"
fi

if ! which jq > /dev/null 2>&1
then
    echo "jq not installed"
    exit 1
fi

# Get email from key
EMAIL=$(jq -r '.client_email' $KEY)
gcloud auth activate-service-account "$EMAIL" --key-file=$KEY
gcloud auth list

echo ""
echo "NOTICE - Reload the kubeconfig after swapping users"
echo ""

