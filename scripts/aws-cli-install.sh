#!/usr/bin/env bash
#
# install AWS CLI, instructions 
# https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

set -e errexit

here=$(cd "$(dirname "${BASH_SOURCE[0]}")" || exit; echo "$PWD")

info() {
  echo "${BASH_SOURCE[0]}: $*"
}

error() {
  info "$*" >&2
  exit 1
}

case $OSTYPE in
  darwin*)
    os='darwin'
    ;;
  linux*)
    os='linux'
    ;;
esac

has_aws(){ command -v aws; }

install_deps()
{
  for pkg in curl
  do
    info "installing dependency: ${pkg}"
    "$here/pkg_install.sh" "$pkg"
  done
}

install()
{
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  sudo ./aws/install
}

# if we are being sourced, nothing below here will run
if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then return 0; fi

if ! has_aws; then
  install_deps
  install
fi

info $(aws --version)

