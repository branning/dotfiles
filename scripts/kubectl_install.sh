#!/usr/bin/env bash
#
# install kubectl client, instructions from
# linux: https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl-binary-with-curl-on-linux
# macos: https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl-binary-with-curl-on-macos

set -e errexit

info() {
  echo "kubectl install: $*"
}

error() {
  info "$*" >&2
  exit 1
}

if ! version=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt); then
  version='v1.14.3'
fi

case $OSTYPE in
  darwin*)
    os='darwin'
    ;;
  linux*)
    os='linux'
    ;;
esac

has_kubectl(){ command -v kubectl; }

# if we are being sourced, nothing below here will run
if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then return 0; fi

info "Downloading kubectl version ${version} for ${os} OS"
curl -LO https://storage.googleapis.com/kubernetes-release/release/${version}/bin/${os}/amd64/kubectl

chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

if has_kubectl; then
  info "we have kubectl!"
  kubectl version
else
  error "no kubectl we having"
fi
