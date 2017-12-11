#!/usr/bin/env bash
#
# install gcloud tools, instructions from
# linux: https://cloud.google.com/sdk/docs/quickstart-linux
# macos: https://cloud.google.com/sdk/docs/quickstart-mac-os-x

set -e errexit

info() {
  echo "gcloud install: $*"
}

error() {
  info "$*" >&2
  exit 1
}

version='182.0.0'

case $OSTYPE in
  darwin*)
    os='darwin'
    ;;
  linux*)
    os='linux'
    ;;
esac

has_gcloud(){ command -v gcloud; }

# if we are being sourced, nothing below here will run
if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then return 0; fi

if false && has_gcloud >/dev/null 2>&1
then
  # gcloud already installed, let's update it and exit
  echo Y | gcloud components update
  exit 0
fi

# Download google-cloud-sdk, and automatically cleanup on exit
url="https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${version}-${os}-$(uname -m).tar.gz"
info "downloading ${url}"
trap "rm -f $(basename $url)" INT EXIT
wget -q "$url"

# Just add water
set -x
destination='/opt/gcloud'
sudo mkdir -p "$destination"
sudo chown `id -u`:`id -g` "$destination"
tar -xzvf $(basename "$url") --directory "$destination"
"$destination"/google-cloud-sdk/install.sh -q --rc-path ~/.profile
source ~/.profile

# make sure we install Kubernetes tools
gcloud components install kubectl -q

# replaces the current shell! exit stage left ... !
#exec -l $SHELL

