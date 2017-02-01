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
    echo $file
    [[ -d `dirname $file` ]] && symbolic='-s' || symbolic=''
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
      subl_dir='/Applications/Sublime Text.app/Contents/SharedSupport/bin'
      user_dir=$HOME/Library/Application\ Support/Sublime\ Text\ 3/Packages/User
      user_settings=$user_dir/Preferences.sublime-settings
      user_keymap=$user_dir/Default\ \(OSX\).sublime-keymap
      ;;
    linux*)
      bin_dir=/usr/bin
      user_dir=$HOME/.config/sublime-text-3/Packages/User
      user_settings=$user_dir/Preferences.sublime-settings
      user_keymap=$user_dir/Default\ \(Linux\).sublime-keymap
      ;;
    *)
      echo >&2 "Don't know how to install sublimetext on ${OSTYPE}!"
      return 1
  esac

  if ! [ -x "${subl_dir}/subl" ]
  then
    case $OSTYPE in
      linux*)    
        echo "Installing sublimetext version ${subl_version}"
        ./sublimetext_install.sh $subl_version
        ;;
      *)
        echo "Sublimetext is not installed, skipping configuration"
        return 0
    esac
  fi

  if ! quiet command -v subl && ! grep -q "${subl_dir}" $HOME/.profile
  then
    echo "Adding Sublime Text bin dir to PATH: ${subl_dir}"
    export PATH="$PATH:${bin_path}"
    cat  <<EOF >>$HOME/.profile

# add sublime text bin to path
if [ -d '${subl_dir}' ]
then
    export PATH="\$PATH:${subl_dir}"
fi
EOF

    # now import the path
    source ~/.profile
  fi

  subl -v # print Sublime Text version
  echo "SublimeText User dir: $user_dir"
  mkdir -p "$user_dir"
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

  # vim-markdown
  clone_update git://github.com/plasticboy/vim-markdown.git

  # neovim support for pathogen
  if command -v nvim
  then
    pathogen_autoload=~/.vim/bundle/vim-pathogen/autoload/pathogen.vim
    mkdir -p $(basename $pathogen_autoload)
    ln -s "$pathogen_autoload" /usr/share/nvim/runtime/pathogen.vim
  fi

  # vim-fugitive requires a config step
  clone_update git://github.com/tpope/vim-fugitive.git
  vim -u NONE -c "helptags vim-fugitive/doc" -c q

  quiet popd
}

# install everything, if we are not being sourced
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  install_dotfiles
  install_goodies
  subl_version=3126
  install_sublimetext_settings
  install_vim_plugins
fi
