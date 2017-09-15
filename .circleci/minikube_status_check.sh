#!/usr/bin/env bash
set -o errexit


echo "searching for localkube process"
ps -aux | grep -i localkube


./minikube status

./kubectl get po --all-namespaces
