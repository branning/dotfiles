#!/bin/sh
#
# Install Git LFS (large file support) via magic

$(cd $(dirname $BASH_SOURCE[0]); echo $PWD)

# install git-lfs apt repo
curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash

# install git-lfs debian package
$here/pkg_install.sh git-lfs

#initialize
git lfs install

