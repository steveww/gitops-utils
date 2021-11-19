#!/bin/sh

if [ -z "$1" ]
then
    echo "Cluster name required as first arg"
    exit 1
fi

kind create cluster \
    --name "$1" \
    --config kind-config.yaml

sleep 3
/bin/echo -n "Deploy metrics server? <y/n> "
read ANS
if [ "$ANS" = "y" ]
then
    kubectl apply -f metrics-server.yaml
fi

watch kubectl get pod -A

