#!/usr/bin/env bash
#
# install using platform-specific package managers

quiet(){ "$@" >/dev/null 2>&1; }

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
      if ! quiet brew list | grep -q "$pkg"
      then
        brew install "$pkg"
      fi
      ;;
    linux*)
      if [ -f /etc/debian_version ]
      then
        if ! quiet dpkg-query -s "$pkg"
        then
          echo "installing dependency: ${pkg}"
          quiet apt install "$pkg" -y
        fi
      elif [ -f /etc/redhat-release ]
      then
        echo "installing dependency: ${pkg}"
        quiet dnf install "$pkg"
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
