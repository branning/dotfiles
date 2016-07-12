#!/bin/bash
#
# Link all the regular files in dotfiles/home/ into ~, with a '.' prefix
#
# For example, dotfiles/home/profile --> ~/.profile
#              dotfiles/home/tmux    --> ~/.tmux

here=$(cd $(dirname $BASH_SOURCE); pwd)

pushd $here/home || { echo "missing $here/home!" >&2; exit 1; }

echo "Linking files from $here/home into ~"
for file in $(find . -maxdepth 1 -type f); do
  ! [ -f $file ] && { echo "$f is not a file!" >&2; exit 1; }
  $t ln -fs $PWD/$file ~/.$file
done

popd

# Not everything here is a dotfile, some are scripts and goodies
#
# install tmux bash completion
$t echo -e "source $(echo $PWD)/scripts/bash_completion_tmux.sh" >> ~/.bash_profile

