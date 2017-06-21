#!/bin/bash
#
# Install Sublimetext text editor

set -o errexit

here=$(dirname $(readlink -f $0 2>/dev/null || $0))

install_sublimetext()
{
  local version deb url
  version=$1
  url="https://download.sublimetext.com/sublime-text_build-${version}_amd64.deb"
  deb="sublimetext.${version}.deb"
  trap "rm -f "$deb""  INT TERM EXIT
  wget -nv -O $deb $url
  sudo dpkg -i $deb
  # reset traps
  trap - INT TERM EXIT
}

install_package_control()
{
  local url filename destination
  url='https://packagecontrol.io/Package%20Control.sublime-package'
  # undo URL encoding and grab last part to make filename
  filename=$(printf '%b' "${url//%/\\x}")
  filename=$(basename "$filename")
  destination="$HOME/.config/sublime-text-3/Installed Packages"
  mkdir -p "$destination"
  wget -nv -O "${destination}/${filename}" "$url"
}

install_packages()
{
  local user_package_dir
  user_package_dir="$HOME/.config/sublime-text-3/Packages/User/"
  mkdir -p "$user_package_dir"
  cp "$here/../sublime/Package Control.sublime-settings" "$user_package_dir"
}

# if we are being sourced, nothing below here will run
if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then return 0; fi

version=${1-3126}
install_sublimetext $version
install_packages
install_package_control
