#!/usr/bin/env bash
set -o errexit


ps -aux | grep -i localkube
docker ps -a
cat ~/.minikube/profiles/minikube/config.json
./minikube status

./kubectl get po --all-namespaces
