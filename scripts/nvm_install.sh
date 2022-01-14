#!/usr/bin/env bash
#
# instructions from https://github.com/creationix/nvm#install-script
#
# set PROFILE=~/.profile to avoid writing to ~/.bashrc, which we don't manage
# with the dotfiles herein

nvm='0.39.1'

curl -s -o- https://raw.githubusercontent.com/creationix/nvm/v${nvm}/install.sh \
  | PROFILE=~/.profile bash

