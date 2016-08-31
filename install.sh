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

install_dotfiles()
{
  here=$(cd $(dirname $BASH_SOURCE); pwd)
  quiet pushd $here/home

  echo "Linking files from $here/home into $HOME"
  for file in $(find * -type f); do
    ln -v -fs $PWD/$file ~/.$file
  done
  quiet popd
}

install_goodies()
{
  # Not everything here is a dotfile, some are scripts and goodies
  #
  # install tmux bash completion
  $d echo -e "source $(echo $PWD)/scripts/bash_completion_tmux.sh" >> ~/.bash_profile
}

install_sublimetext_settings()
{
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
}

install_vim_plugins()
{
  # the ~/.vim file has a line to autoload pathogen, which will autoload all plugins
  # that we install to ~/.vim/bundle
  # so we install pathogen, and some plugins, there
  mkdir -p $HOME/.vim/bundle
  quiet pushd $HOME/.vim/bundle
  git clone git://github.com/tpope/vim-pathogen.git

  # neovim support for pathogen
  ln -s ~/.vim/bundle/vim-pathogen/autoload/pathogen.vim /usr/share/nvim/runtime/pathogen.vim

  # vim-fugitive requires a config step
  git clone git://github.com/tpope/vim-fugitive.git
  vim -u NONE -c "helptags vim-fugitive/doc" -c q

  quiet popd
}

# install everything, if we are not being sourced
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  install_dotfiles
  install_goodies
  install_sublimetext_settings
  install_vim_plugins
fi
