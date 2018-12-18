#!/usr/bin/env bash
#
# Install Spotify client

error() {
  echo "`basename $0` $*" >&2
  exit 1
}

become_root() {
  if ! [ $EUID -eq 0 ]
  then
    exec sudo /bin/bash "$0" "$@"
  fi
}

# if we are being sourced, nothing below here will run
if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then return 0; fi


case $OSTYPE in
  linux*)
    become_root
    # from https://www.spotify.com/us/download/linux/ on 9/19/2017
    # 1. Add the Spotify repository signing keys to be able to verify downloaded
    # packages
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886 0DF731E45CE24F27EEEB1450EFDC8610341D9410

    # 2. Add the Spotify repository
    echo deb http://repository.spotify.com stable non-free \
      | tee /etc/apt/sources.list.d/spotify.list

    # 3. Update list of available packages
    apt-get update

    # 4. Install Spotify
    apt-get install -y spotify-client
    ;;
  darwin*)
    brew cask install spotify;;
  *) 
    error "don't know how to install $OSTYPE yet"
    ;;
esac

