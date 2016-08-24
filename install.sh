#!/bin/bash
#
# Link all the regular files in dotfiles/home/ into ~, with a '.' prefix
#
# For example, dotfiles/home/profile --> ~/.profile
#              dotfiles/home/tmux    --> ~/.tmux

#set -o xtrace

error()
{ echo "$@" >&2
  exit 1
}

quiet()
{ $@ >/dev/null; }

# for dry run, set d=echo
#d=echo

here=$(cd $(dirname $BASH_SOURCE); pwd)
echo "Linking files from $here/home into $HOME"

[ -d $here/home ] || error "missing $here/home!"
quiet pushd $here/home
for file in $(find * -type f); do
  #[ "$d" ] && echo file=$file
  #! [ -f $file ] && { echo "$f is not a file!" >&2; exit 1; }
  $d ln -v -fs $PWD/$file ~/.$file
done
quiet popd

# Not everything here is a dotfile, some are scripts and goodies
#
# install tmux bash completion
$d echo -e "source $(echo $PWD)/scripts/bash_completion_tmux.sh" >> ~/.bash_profile

# install sublimetext user settings
case $OSTYPE in
  darwin*)
    user_dir=$HOME/Library/Application\ Support/Sublime\ Text\ 3/Packages/User
    user_settings=$user_dir/Preferences.sublime-settings
    user_keymap=$user_dir/Default\ \(OSX\).sublime-keymap
    ;;
  linux*)
    user_dir=$HOME/.config/sublime-text-3/Packages/User
    user_settings=$user_dir/Preferences.sublime-settings
    user_keymap=$user_dir/Default\ \(Linux\).sublime-keymap
    ;;
esac

echo "SublimeText User dir: $user_dir"
[ -d "$user_dir" ] || error "Sublime Text user preferences dir missing!"
cp sublime/sublime-settings "$user_settings"
cp sublime/sublime-keymap "$user_keymap"

