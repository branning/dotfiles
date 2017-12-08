#!/usr/bin/env bash
#
# install minikube according to directions at

set -o errexit

error() {
  echo >&2 "$*"
  exit 1
}

release='v0.24.1'

case $OSTYPE in
  linux*)  platform='linux';;
  darwin*) platform='darwin';;
  *)       error "Platform '$OSTYPE' is not supported yet";;
esac

# download minikube and install to /usr/local/bin
curl -Lo minikube https://storage.googleapis.com/minikube/releases/"$release"/minikube-"$platform"-amd64 
chmod +x minikube 
sudo mv minikube /usr/local/bin/
