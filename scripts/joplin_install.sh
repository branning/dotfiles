#!/usr/bin/env bash
#
# Install Joplin note taking and to-do application with synchronization capabilities

case $OSTYPE in
  linux*)
    if [ -z ${XDG_CURRENT_DESKTOP+x} ]
    then
      echo "non-graphical session, skipping joplin (XDG_CURRENT_DESKTOP not defined)"
      break
    fi
    script_url='https://raw.githubusercontent.com/laurent22/joplin/master/Joplin_install_and_update.sh'
    wget -O - "$script_url" | bash
    ;;
  darwin*)
    brew cask install joplin;;
  cygwin*|msys*|mingw32*)
    scoop install joplin;;
esac

