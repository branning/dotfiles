#!/usr/bin/env bash
#
# install Astral uv Python management tool
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

has_uv(){ command -v uv >/dev/null 2>&1; }

install_deps()
{
  local deps=$*
  for pkg in ${deps[@]}
  do
    info "installing dependency: ${pkg}"
    "$here/pkg_install.sh" "$pkg"
  done
}

install_windows()
{
  powershell -c "irm https://astral.sh/uv/install.ps1 | iex"
}

install_posix()
{
  curl -LsSf https://astral.sh/uv/install.sh | sh
}

# if we are being sourced, nothing below here will run
if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then return 0; fi

if ! has_uv; then
  case $OSTYPE in
    darwin*|linux*)
      install_deps curl
      install_posix
      ;;
    msys|win32)
      install_windows
      ;;
  esac
fi

info $(command -v uv) $(uv --version)

