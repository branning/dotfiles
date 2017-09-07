#!/usr/bin/env bash
#
# install using platform-specific package managers

error()
{ echo "$@" >&2
  exit 1
}

if ! [ $EUID -eq 0 ]
then
  exec sudo /bin/bash "$0" "$@"
fi

for pkg in $@
do
  case $OSTYPE in
    darwin*)
      brew install "$pkg"
      ;;
    linux*)
      if [ -f /etc/debian_version ]
      then
        apt install "$pkg" -y
      elif [ -f /etc/redhat-release ]
      then
        dnf install "$pkg"
      else
        error "can't install packages on Linux flavor: (contents of /etc/os-release)"
        cat /etc/os-release
      fi
      ;;
    cygwin*|msys*|mingw32*)
      scoop install yarn
      ;;
  esac

done
