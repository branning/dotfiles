#!/usr/bin/env bash
#
# Install Microsoft Visual Studio Code for Node development

set -o errexit
set -o pipefail

here=$(cd $(dirname $BASH_SOURCE); echo $PWD)

error() {
  echo "$*" >&2
  exit 1
}

# Check for required tools
check_tool() {
  for tool in $@
  do
    if ! command -v "$tool" >/dev/null 2>&1
    then
      error "I require ${tool} but it's not installed.  Aborting."
    fi
  done
}

become_root() {
  if ! [ $EUID -eq 0 ]
  then
    exec sudo /bin/bash "$0" "$@"
  fi
}

install_vs_repo() {
  curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
  mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
  sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
  }

# if we are being sourced, nothing below here will run
if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then return 0; fi

case $OSTYPE in
  linux*)
    check_tool curl gpg
    become_root
    install_vs_repo
    apt update
    apt install -y code # or code-insiders
    ;;
  darwin*)
    check_tool brew
    brew install --cask visual-studio-code
    ;;
  cygwin*|msys*|mingw32*)
    check_tool scoop
    scoop bucket add extras
    scoop install vscode
    ;;
esac
