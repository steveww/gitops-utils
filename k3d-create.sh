#!/bin/sh

if [ -z "$1" ]
then
    echo "cluster name required as first arg"
    exit 1
fi


k3d cluster create "$1" \
    --api-port 6443 \
    --agents 3 \
    --servers 1

