#!/usr/bin/env bash
#
# Install g++ compiler if it's missing

quiet(){ "$@" >/dev/null 2>&1; }

info(){ echo "g++ install: $*"; }

become_root() {
  if ! [ $EUID -eq 0 ]
  then
    exec sudo /bin/bash "$0" "$@"
  fi
}

become_root

if ! quiet command -v g++
  then
  case $OSTYPE in
    darwin*|win*)
      info "whoops don't know how to install g++ on macos or windows yet" 
      ;;
    linux*) 
      info "installing build-essential"
      quiet apt install build-essential -y
      info "complete!"
      ;;
  esac
fi

