#!/usr/bin/env bash
#
# install brew, or uninstall if given 'uninstall' argument
# copied from https://brew.sh/ on 12/25/2017

case "$1" in
  uninstall)
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall)"
    exit $?
    ;;
  *) : ;;
esac

# if we didn't get the word to uninstall, install!
TRAVIS=1 /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
