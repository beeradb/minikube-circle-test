#!/usr/bin/env bash
set -o errexit

export MINIKUBE_VERSION=0.21.0
export KUBECTL_VERSION=1.7.4
export HELM_VERSION=2.5.1


# Docker setup
sudo apt-get remove -qq docker docker-engine
sudo apt-get update -qq
sudo apt-get install -qq apt-transport-https ca-certificates  curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Per docker docs, you always need the stable repository, even if you want to install edge builds as well.
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) edge"
sudo apt-get update -qq
sudo apt-get install -qq docker-ce=17.05.0~ce-0~ubuntu-$(lsb_release -cs)

# install nsenter, which is a hard dependency for the kubelet and is not
# installed on ubuntu 14.04.
cat <<EOF | docker run -i --rm -v "`pwd`:/tmp" ubuntu:14.04
apt-get update
apt-get install -y git bison build-essential libncurses5-dev libslang2-dev gettext zlib1g-dev libselinux1-dev debhelper lsb-release pkg-config po-debconf autoconf automake autopoint libtool
cd /tmp
git clone git://git.kernel.org/pub/scm/utils/util-linux/util-linux.git
cd util-linux
./autogen.sh
./configure --without-python --disable-all-programs --enable-nsenter
make nsenter
EOF
sudo cp -v util-linux/nsenter /usr/local/bin
sudo chmod ugo+x /usr/local/bin/nsenter
sudo rm -rf util-linux


#Installing minikube https://github.com/kubernetes/helm/releases
echo "Installing helm............................"
curl -Lo helm.tar.gz https://storage.googleapis.com/kubernetes-helm/helm-v$HELM_VERSION-linux-amd64.tar.gz && tar -zxvf helm.tar.gz && rm -rf helm.tar.gz && chmod +x linux-amd64/helm && sudo mv linux-amd64/helm /usr/local/bin/
