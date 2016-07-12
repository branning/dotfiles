#!/bin/bash
#
# Link all the regular files in dotfiles/home/ into ~, with a '.' prefix
#
# For example, dotfiles/home/profile --> ~/.profile
#              dotfiles/home/tmux    --> ~/.tmux

# for dry run, set d=echo
#d=echo

here=$(cd $(dirname $BASH_SOURCE); pwd)
echo "Linking files from $here/home into ~"

pushd $here/home >/dev/null || { echo "missing $here/home!" >&2; exit 1; }
for file in $(find * -type f); do
  #[ "$d" ] && echo file=$file
  #! [ -f $file ] && { echo "$f is not a file!" >&2; exit 1; }
  $d ln -v -fs $PWD/$file ~/.$file
done
popd >/dev/null

# Not everything here is a dotfile, some are scripts and goodies
#
# install tmux bash completion
$d echo -e "source $(echo $PWD)/scripts/bash_completion_tmux.sh" >> ~/.bash_profile

