#!/usr/bin/env bash
#
# instruction from https://krypt.co/install/

here=$(cd $(dirname $BASH_SOURCE[0]); echo $PWD)

if ! command -v curl >/dev/null 2>&1
then
  echo "installing dependency: curl"
  $here/pkg_install.sh curl
fi

if ! command -v kr >/dev/null 2>&1
then
  curl https://krypt.co/kr | sh
fi

if ! [ -f ~/.ssh/id_kryptonite.pub ]
then
  kr pair
fi

kr sshconfig
