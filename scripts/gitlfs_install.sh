#!/bin/bash
#
# Install Git LFS (large file support) via magic

here=$(cd $(dirname $BASH_SOURCE[0]); echo $PWD)

case $OSTYPE in
  linux*)
    (
    source /etc/os-release
    if [ "$ID" = debian ] || [ "$ID_LIKE" = debian ]
    then
      # install git-lfs apt repo
      curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash
    fi
    )
    ;;
esac

# install git-lfs debian package
$here/pkg_install.sh git-lfs
