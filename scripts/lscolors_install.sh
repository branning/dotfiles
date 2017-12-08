#!/usr/bin/env bash
#
# Install colorized filter for about 300 filetypes
# Thanks to @trapd00r

set -o errexit

wget -q https://raw.github.com/trapd00r/LS_COLORS/master/LS_COLORS -O $HOME/.dircolors

lscolors_comment='LS_COLORS colorized file filters from http://github.com/trapd00r/LS_COLORS'
if ! grep -q "$lscolors_comment" ~/.bashrc
then
  cat <<EOF >> $HOME/.bashrc

# ${lscolors_comment}
if [ -f \$HOME/.dircolors ]
then
  eval \$(dircolors -b \$HOME/.dircolors)
fi
EOF
fi
