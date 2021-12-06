#!/bin/sh

set -e
#set -x

if [ -z "$1" ]
then
    echo "VM name required as first arg"
    exit 1
fi

HOST="$1"

STATUS=$(gcloud compute instances list | awk -v host=$HOST '{ if($1 ~ host && $0 ~ "RUNNING") {print "OK"}}')
if [ "$STATUS" != "OK" ]
then
    echo "$HOST not found or not running"
    gcloud compute instances list
    exit 1
fi

cd $HOME/.kube
gcloud compute scp ${HOST}:.kube/config $HOST
