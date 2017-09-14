#!/usr/bin/env bash
#
# install Oracle JDK

set -o errexit

quiet(){ "$@" >/dev/null 2>&1; }

error()
{ echo "$@" >&2
  exit 1
}

if ! [ $EUID -eq 0 ]
then
  exec sudo /bin/bash "$0" "$@"
fi

case $OSTYPE in
  linux*)
    if [ -f /etc/debian_version ]
    then
      apt-add-repository ppa:webupd8team/java -y
      apt update
      echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" \
        | sudo debconf-set-selections
      apt install oracle-java8-installer -y
      apt install oracle-java8-set-default -y
    else
      error "don't know how to install Oracle JDK on Linux flavor: (contents of /etc/os-release)"
      cat /etc/os-release
    fi
    ;;
  *)
    error "don't know how to install Oracle JDK on $OSTYPE yet"
    ;;
esac
