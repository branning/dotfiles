#!/usr/bin/env bash
#
# Install Joplin note taking and to-do application with synchronization capabilities

case $OSTYPE in
  linux*)
    if [ -z ${XDG_CURRENT_DESKTOP+x} ]
    then
      echo "non-graphical session, skipping joplin (XDG_CURRENT_DESKTOP not defined)"
    else
      script_url='https://raw.githubusercontent.com/laurent22/joplin/master/Joplin_install_and_update.sh'
      wget -O - "$script_url" | bash
    fi
    ;;
  darwin*)
    brew install --cask joplin;;
  cygwin*|msys*|mingw32*)
    sccop bucket add extras
    scoop install joplin
    ;;
esac

