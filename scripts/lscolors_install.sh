#!/usr/bin/env bash
#
# Install colorized filter for about 300 filetypes
# Thanks to @trapd00r

set -o errexit

here=$(cd "$(dirname "${BASH_SOURCE[0]}")" || exit; echo "$PWD")

if ! command -v wget >/dev/null 2>&1
then
  $here/pkg_install.sh wget
fi

wget -q https://raw.github.com/trapd00r/LS_COLORS/master/LS_COLORS -O $HOME/.dircolors

case $OSTYPE in
  darwin*)
    # on macos we need to install coreutils in order to get `dircolors`
    $here/pkg_install.sh coreutils
    # and we also need to call it `gdircolors` instead of `dircolors`
    dircolors='gdircolors'
    ;;
  *)
   # on Linux and Windows, we can call the original name of the tools
   dircolors='dircolors';;
esac

lscolors_comment='LS_COLORS colorized file filters from http://github.com/trapd00r/LS_COLORS'
if ! grep -q "$lscolors_comment" ~/.bashrc
then
  cat <<EOF >> $HOME/.bashrc

# ${lscolors_comment}
if [ -f \$HOME/.dircolors ]
then
  eval \$(${dircolors} -b \$HOME/.dircolors)
fi
EOF
fi

