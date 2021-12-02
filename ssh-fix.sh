#!/bin/sh

kubectl exec -ti deployment/mccp-chart-cluster-service -n wego-system -- sh -c "ssh-keyscan github.com gitlab.com bitbucket.org ssh.dev.azure.com vs-ssh.visualstudio.com > /root/.ssh/known_hosts"

