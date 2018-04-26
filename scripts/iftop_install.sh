#!/usr/bin/env bash
#
# iftop is like top for networking

set -o errexit
set -o xtrace

version='0.17'
tarfile="iftop-${version}.tar.gz"
iftopdir=~/src/iftop-${version}

install_deps()
{
  deps='
    build-essential
    libpcap-dev
    ncurses-dev
    '
  for dep in $deps
  do
    sudo apt install -y "$dep"
  done
}

get_iftop()
{
  mkdir -p ~/src
  cd ~/src
  wget -q "http://www.ex-parrot.com/~pdw/iftop/download/${tarfile}"
  tar -xzf "$tarfile" 
  # $iftopdir should exist now
}

build_iftop()
{
  cd "$iftopdir"
  ./configure
  make
}

install_iftop()
{
  mkdir -p ~/bin
  cd $iftopdir
  cp ./iftop ~/bin/
}

cleanup()
{
  cd ~/src
  rm -rf ${iftopdir}*
}

# install ninja if we were executed
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  get_iftop
  install_deps
  build_iftop
  install_iftop
  cleanup
fi
