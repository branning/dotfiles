#!/bin/bash
#
# Install Git LFS (large file support) via magic

here=$(cd "$(dirname "${BASH_SOURCE[0]}")" || exit; echo "$PWD")

add_gitlfs_repo() {
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
}

# install ninja if we were executed
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  if command -v git-lfs >/dev/null 2>&1; then
    echo "Git LFS is installed: $(command -v git-lfs)"
    exit 0
  fi
  # install git-lfs debian package
  add_gitlfs_repo
  "$here/pkg_install.sh" git-lfs
fi

