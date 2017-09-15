#!/usr/bin/env bash

curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube
curl -Lo kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && chmod +x kubectl


mkdir $HOME/.kube || true
touch $HOME/.kube/config

./minikube config set WantKubectlDownloadMsg false

sudo -E ./minikube start --vm-driver=none

# this for loop waits until kubectl can access the api server that minikube has created
for i in {1..150} # timeout for 5 minutes
do
   ./kubectl get po &> /dev/null
   if [ $? -ne 1 ]; then
      echo "kubernetes is ready"
      break
  fi
  sleep 2
done

./kubectl apply -f deployments/nginx.yaml

./.circleci/wait_for_deployment.sh default nginx-deployment

./minikube status

sleep 120

./minikube status
./kubectl get po --all-namespaces

ps -aux
docker ps -a
cat ~/.minikube/profiles/minikube/config.json
