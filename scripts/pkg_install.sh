#!/usr/bin/env bash
#
# install using platform-specific package managers

here=$(cd "$(dirname "${BASH_SOURCE[0]}")" || exit; echo "$PWD")

quiet(){ "$@" >/dev/null 2>&1; }

error()
{ echo "$@" >&2
  exit 1
}

check_brew() {
  if ! command -v brew >/dev/null 2>&1
  then
    $here/brew_install.sh
  fi
}

# if we are being sourced, nothing below here will run
if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then return 0; fi

VERBOSE=${VERBOSE:-0}

case $OSTYPE in
  darwin*)
    check_brew;;
  *)
    if ! [ $EUID -eq 0 ]
    then
      exec sudo /bin/bash "$0" "$@"
    fi
    ;;
esac

for pkg in $@
do
  case $OSTYPE in
    darwin*)
      if ! brew list 2>/dev/null | grep -q "$pkg"
      then
        brew install "$pkg"
      elif ((VERBOSE))
      then echo "ok $pkg"
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
      scoop install "$pkg"
      ;;
  esac

done
