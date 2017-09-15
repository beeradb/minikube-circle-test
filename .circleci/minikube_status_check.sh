#!/usr/bin/env bash
set -o errexit


ps -aux
docker ps -a
cat ~/.minikube/profiles/minikube/config.json
./minikube status

./kubectl get po --all-namespaces
