#!/usr/bin/env bash
#
# install gcloud tools, instructions from
# linux: https://cloud.google.com/sdk/docs/quickstart-linux
# macos: https://cloud.google.com/sdk/docs/quickstart-mac-os-x

set -e errexit

info() {
  echo "gcloud install: $*"
}

version='170.0.0'

case $OSTYPE in
  darwin*)
    os='darwin'
    ;;
  linux*)
    os='linux'
    ;;
esac

url="https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${version}-${os}-$(uname -m).tar.gz"
wget -q "$url"
tar -xzvf $(basename "$url")
rm $(basename "$url")
./google-cloud-sdk/install.sh -q --rc-path ~/.profile
exec -l $SHELL
