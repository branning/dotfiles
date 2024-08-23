#!/usr/bin/env bash
#
# install 1Password op CLI, instructions 
# https://developer.1password.com/docs/cli/get-started/

set -e errexit

here=$(cd "$(dirname "${BASH_SOURCE[0]}")" || exit; echo "$PWD")

info() {
  echo "${BASH_SOURCE[0]}: $*"
}

error() {
  info "$*" >&2
  exit 1
}

has_op(){ command -v op >/dev/null 2>&1; }

install_deps()
{
  local deps=$*
  for pkg in ${deps[@]}
  do
    info "installing dependency: ${pkg}"
    "$here/pkg_install.sh" "$pkg"
  done
}

install_darwin()
{
  brew install 1password-cli
}

install_linux()
{
  sudo -s \
  curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
  gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/$(dpkg --print-architecture) stable main" |
  tee /etc/apt/sources.list.d/1password.list
  mkdir -p /etc/debsig/policies/AC2D62742012EA22/
  curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | \
  tee /etc/debsig/policies/AC2D62742012EA22/1password.pol
  mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22
  curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
  gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg
  apt update && apt install 1password-cli
}

# if we are being sourced, nothing below here will run
if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then return 0; fi

if ! has_op; then
  case $OSTYPE in
    darwin*)
      install_darwin
      ;;
    linux*)
      install_deps curl gpg
      install_linux
      ;;
  esac
fi

info $(command -v op) $(op --version)

