#!/bin/sh

for POD in $(kubectl -n wego-system get pod --no-headers | awk '{print $1}')
do
    echo "$POD"
    kubectl -n wego-system logs "$POD" | fgrep -i error
done
