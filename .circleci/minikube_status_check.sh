#!/usr/bin/env bash
set -o errexit

./minikube status

./kubectl get po --all-namespaces
