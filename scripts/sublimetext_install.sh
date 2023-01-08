#!/bin/bash
#
# Install Sublimetext text editor

set -o errexit

readlink=$(command -v greadlink || command -v readlink)
here=$(dirname $($readlink -f $0 2>/dev/null || $0))

debian_install_sublimetext()
{
  gpg_url='https://download.sublimetext.com/sublimehq-pub.gpg'
  wget -qO - "$gpg_url" | sudo apt-key add -
  channel='stable' # or 'dev'
  echo "deb https://download.sublimetext.com/ apt/${channel}/" \
    | sudo tee /etc/apt/sources.list.d/sublime-text.list
  sudo apt update
  sudo apt install sublime-text
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

case $OSTYPE in
  linux*)
    debian_install_sublimetext
    ;;
  darwin*)
    brew install --cask sublime-text
    ;;
  win*|msys*)
    scoop bucket add extras
    scoop install sublime-text
    ;;
  *)
    error "$OSTYPE isn't supported yet for SublimeText install"
    ;;
esac

install_packages
install_package_control
