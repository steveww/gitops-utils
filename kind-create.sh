#!/bin/sh

if [ -z "$1" ]
then
    echo "Cluster name required as first arg"
    exit 1
fi

kind create cluster \
    --name "$1" \
    --config kind-config.yaml

