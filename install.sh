#!/bin/bash
#
# Link all the regular files in dotfiles/home/ into ~, with a '.' prefix
#
# For example, dotfiles/home/profile --> ~/.profile
#              dotfiles/home/tmux    --> ~/.tmux

#set -o xtrace

here=$(cd $(dirname $BASH_SOURCE); pwd)

error()
{ echo "$@" >&2
  exit 1
}

quiet()
{ "$@" >/dev/null 2>&1; }

git_clean()
{
    if quiet git diff --exit-code && quiet git diff --cached --exit-code
    then return 0
    else return 1
    fi
}

reponame()
{   # from a git url, extract default repo directory name
    url=$1
    dir=`basename $url`
    # delete '.git' from the right end.
    # see http://tldp.org/LDP/abs/html/parameter-substitution.html#PCTPATREF
    dir=${dir%%.git}
    echo $dir
}

clone_update()
{
  # clone a git repo, or if already cloned, pull
  giturl=$1
  repo=`reponame $giturl`
  quiet git clone ${giturl} || \
  { quiet pushd $repo
    if git_clean
    then
        quiet git pull
    else
        echo "it's dirty! Changed files:"
        git status --porcelain
    fi
    quiet popd
  }
}

install_dotfiles()
{
  quiet pushd $here/home
  local symbolic # whether to make symlinmks. systemd hates them!

  echo "Linking files from $here/home into $HOME"
  for file in $(find * -type f); do
    #printf "  "
    [[ $file =~ 'systemd' ]] && symbolic='' || symbolic='-s'
    cp -afv ${symbolic} $PWD/$file ~/.$file
  done
  quiet popd
}

install_goodies()
{
  # Not everything here is a dotfile, some are scripts and goodies
  #
  [ -f ~/.bash_profile ] && sed -i '/bash_completion_tmux.sh/d' ~/.bash_profile
  tmux_comment='install tmux bash completion'
  if ! grep -q "$tmux_comment" ~/.profile
  then
    echo 'Installing tmux Bash completion'
    cat <<TMUX >> ~/.profile

# ${tmux_comment}
if [ -n "\$BASH_VERSION" ]
then
    source $here/scripts/bash_completion_tmux.sh
fi
TMUX
  fi
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
  echo "Installing vim plugins"

  # the ~/.vim file has a line to autoload pathogen, which will autoload all plugins
  # that we install to ~/.vim/bundle
  # so we install pathogen, and some plugins, there
  mkdir -p $HOME/.vim/bundle
  quiet pushd $HOME/.vim/bundle
  clone_update git://github.com/tpope/vim-pathogen.git

  # neovim support for pathogen
  ln -s ~/.vim/bundle/vim-pathogen/autoload/pathogen.vim /usr/share/nvim/runtime/pathogen.vim

  # vim-fugitive requires a config step
  clone_update git://github.com/tpope/vim-fugitive.git
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
