# kind-utils

A collection of utilities and files to help with setting up and running Kubernetes in Docker (kind).

## Tips

Set up an shell alias to use ssh to tunnel the K8S API port.

```shell
alias kind-tunnel='ssh -L 6443:localhost:6443'
```
