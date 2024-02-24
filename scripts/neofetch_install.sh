#!/bin/bash
#
# Install Neofetch system info tool

set -o errexit

version='7.1.0'
repo='git@github.com:dylanaraps/neofetch'
artifacts=~/src
neofetchdir="$artifacts/neofetch"

get_neofetch()
{
  mkdir -p "$artifacts"
  cd "$artifacts"
  git clone "$repo" -b "$version"
  # $neofetchdir should exist now
}

install_neofetch()
{
  cd $neofetchdir
  sudo make install
}

# install ninja if we were executed
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  if command -v neofetch >/dev/null 2>&1; then
    echo "Neofetch is installed: $(command -v neofetch)"
    exit 0
  fi
  get_neofetch
  install_neofetch
fi
