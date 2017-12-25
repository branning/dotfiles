#!/usr/bin/env bash
#
# instruction from https://krypt.co/install/

if ! command -v kr >/dev/null 2>&1
then
  curl https://krypt.co/kr | sh
fi

if ! [ -f ~/.ssh/id_kryptonite.pub ]
then
  kr pair
fi

kr sshconfig
