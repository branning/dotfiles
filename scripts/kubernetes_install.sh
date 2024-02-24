#!/usr/bin/env bash
#
# Install kubectl for controlling local and remote kubernetes clusters
# Install helm for managing charts on local and remote kubernetes clusters
# Install minikube and virtualbox for a local dev environment

set -o errexit

here=$(cd "$(dirname "${BASH_SOURCE[0]}")" || exit; echo "$PWD")

if ! command -v kubectl >/dev/null 2>&1
then
  $here/kubectl_install.sh
fi

if ! command -v virtualbox >/dev/null 2>&1
then
  $here/virtualbox_install.sh
fi

if ! command -v minikube >/dev/null 2>&1
then
  $here/minikube_install.sh
fi
kubectl config use-context minikube

if ! [[ $(minikube status --format "{{.MinikubeStatus}}") == Running ]]
then
  minikube start
fi

if ! command -v helm >/dev/null 2>&1
then
  $here/helm_install.sh
fi

if ! helm version >/dev/null 2>&1
then
  helm init
fi

