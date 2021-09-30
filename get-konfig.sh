#!/bin/sh

set -e

CONFIG=$(mktemp)
trap "rm -f $CONFIG" 0 1 2 3

if [ -z "$1" ]
then
    echo "remote account required as first arg"
    exit 1
fi
SSH_REMOTE="$1"

if [ ! -d "$HOME/.kube" ]
then
    echo "$HOME/.kube does not exist, creating it"
    mkdir "$HOME/.kube"
fi

scp $SSH_REMOTE:.kube/config $CONFIG
cat $CONFIG >> $HOME/.kube/config

