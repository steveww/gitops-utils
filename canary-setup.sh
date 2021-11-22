#!/bin/sh

COMMANDS="kubectl kubectx gitops linkerd helm"

set -e

checkOK() {
    echo ""
    /bin/echo -n "$1 <y/n> "
    read ANS
    if [ "$ANS" != "y" ]
    then
        echo "Bye"
        exit 0
    fi
}

clear
if [ $(tput cols) -lt 100 ]
then
    echo "Terminal is too narrow. Expand to at least 100 cols"
    exit 1
fi

clear
echo "Checking for commands"
unset MISSING
for CMD in $COMMANDS
do
    if ! which $CMD
    then
        MISSING="$MISSING $CMD"
    fi
done
if [ -n "$MISSING" ]
then
    echo "I cant go on. Install $MISSING"
    exit 1
fi

clear
echo "Kubernetes context"
echo "=================="
echo ""
kubectx
checkOK "Connected to the correct cluster?"

gitops install
checkOK "GitOps installed OK?"
clear

linkerd check --pre
checkOK "Linkerd check OK?"
linkerd install | kubectl apply -f -
linkerd check
checkOK "Linked installed OK?"
clear
linkerd viz install | kubectl apply -f -
linkerd viz check
checkOK "Linkerd VIZ installed OK?"

clear
# check if repo exists
CHECK=$(helm repo list | awk '/^flagger/ {print $1}')
if [ -z "$CHECK" ]
then
    helm repo add flagger https://flagger.app
else
    echo "flagger repo exists"
fi
helm repo update
kubectl apply -f https://raw.githubusercontent.com/fluxcd/flagger/main/artifacts/flagger/crd.yaml
helm upgrade -i flagger flagger/flagger \
    --namespace=linkerd \
    --set crd.create=false \
    --set meshProvider=linkerd \
    --set metricsServer=http://prometheus.linkerd-viz:9090

unset RUNNING
while [ -z "$RUNNING" ]
do
    STATE=$(kubectl -n linkerd get pod | awk '/^flagger/ {print $3}')
    echo "flagger $STATE"
    if [ "$STATE" = "Running" ]
    then
        RUNNING=1
    fi
    sleep 1
done

clear
kubectl create ns loadtest
kubectl annotate ns loadtest 'linkerd.io/inject=enabled'
helm upgrade -i loadtester flagger/loadtester \
    --namespace=loadtest \
    --set cmd.timeout=1h

