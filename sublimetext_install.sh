#!/bin/bash
#
# setup and enable Rescuetime service

set -o errexit

install_sublimetext()
{
  version=$1
  deb="sublimetext.${version}.deb"
  trap "rm -f "$deb""  INT TERM EXIT
  url="https://download.sublimetext.com/sublime-text_build-${version}_amd64.deb"
  wget -nv -O $deb $url
  sudo dpkg -i $deb
}


# if we are being sourced, nothing below here will run
if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then return 0; fi

version=${1-3126}
install_sublimetext $version

