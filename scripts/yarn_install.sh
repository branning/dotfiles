#!/usr/bin/env bash
#
# install yarn node package manager manager
# instructions from https://yarnpkg.com/en/docs/install

curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -

repo='https://dl.yarnpkg.com/debian/'
if ! grep "$repo" /etc/apt/sources.list.d/yarn.list
then
  echo "deb ${repo} stable main" \
    | sudo tee /etc/apt/sources.list.d/yarn.list
fi

sudo apt update && sudo apt install yarn -y

