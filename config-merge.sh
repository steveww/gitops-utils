#!/bin/sh

# Merges the given config file into the default config - $HOME/.kube/config

set -e

MERGED=$(mktemp)
trap 'rm -f $MERGED' 0 1 2 3

if [ -z "$1" ]
then
    echo "New config file required as first arg"
    exit 1
fi

if [ ! -f "$1" ]
then
    echo "$1 is not found or not a regular file"
    exit 1
fi

KUBECONFIG="$HOME/.kube/config:$1" kubectl config view --flatten > $MERGED

echo "Backing up previous and updating new config"
cp $HOME/.kube/config $HOME/.kube/config.bak
cp $MERGED $HOME/.kube/config
