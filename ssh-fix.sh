#!/bin/sh

kubectl exec \
    -it \
    -n wego-system \
    deployment/mccp-chart-cluster-service \
    -- sh -c "ssh-keyscan github.com > /root/.ssh/known_hosts"

