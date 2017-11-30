#!/bin/bash
#
# Link all the regular files in dotfiles/home/ into ~, with a '.' prefix
#
# For example, dotfiles/home/profile --> ~/.profile
#              dotfiles/home/tmux    --> ~/.tmux

#set -o xtrace

here=$(cd $(dirname $BASH_SOURCE); pwd)

error() {
  echo "`basename $0` error: $*" >&2
  exit 1
}

quiet()
{
  "$@" >/dev/null 2>&1
  return $?
}

info() {
  echo "`basename $0`: $*"
}

install_deps()
{
  for pkg in git curl 
  do
    info "installing dependency: ${pkg}"
    $here/scripts/pkg_install.sh "$pkg"
  done
}

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

clone_deep()
{
  local giturl
  giturl="$1"
  git clone "$giturl" || return 1
  quiet pushd `reponame $giturl`
  git submodule update --init --recursive
  quiet popd
}

clone_update()
{
  # clone a git repo, or if already cloned, pull
  giturl="$1"
  repo=`reponame $giturl`
  echo "  cloning ${giturl}"
  if ! quiet clone_deep "$giturl"
  then
    quiet pushd $repo
    if git_clean
    then
        quiet git pull
    else
        echo "it's dirty! Changed files:"
        git status --porcelain
    fi
    quiet popd
  fi
}

install_dotfiles()
{
  quiet pushd $here/home
  local symbolic # whether to make symlinmks. systemd hates them!

  echo "Linking files from $here/home into $HOME"
  for file in $(find * -type f); do
    [[ -d `dirname $file` ]] && symbolic='-s' || symbolic=''
    ln -v -f "$symbolic" $PWD/$file ~/.$file
  done
  quiet popd
}

install_goodies()
{
  # Not everything here is a dotfile, some are scripts and goodies

  # Install bash-completion with fewer bugs
  $here/scripts/bash_completion.sh

  [ -f ~/.bash_profile ] && sed -ie '/bash_completion_tmux.sh/d' ~/.bash_profile
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

  git_comment='install git bash completion'
  if ! grep -q "$git_comment" ~/.profile
  then
    echo 'Installing git Bash completion'
    completion_url='https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash'
    $here/scripts/pkg_install.sh curl
    curl -s "$completion_url" -o "$here/scripts/git-completion.bash"
    cat <<GIT >> ~/.profile

# ${git_comment}
if [ -n "\$BASH_VERSION" ]
then
  source $here/scripts/git-completion.bash
fi
GIT
  fi
}

install_sublimetext()
{
  local settings
  # install sublimetext user settings
  case $OSTYPE in
    darwin*)
      subl_dir='/Applications/Sublime Text.app/Contents/SharedSupport/bin'
      user_dir=$HOME/Library/Application\ Support/Sublime\ Text\ 3/Packages/User
      user_keymap=$user_dir/Default\ \(OSX\).sublime-keymap
      ;;
    linux*)
      bin_dir=/usr/bin
      user_dir=$HOME/.config/sublime-text-3/Packages/User
      user_keymap=$user_dir/Default\ \(Linux\).sublime-keymap
      ;;
    *)
      echo >&2 "Don't know how to install sublimetext on ${OSTYPE}!"
      return 1
  esac

  if ! command -v subl
  then
    case $OSTYPE in
      linux*)
        echo "Installing sublimetext from apt repo"
        ./scripts/sublimetext_install.sh
        ;;
      *)
        echo "Sublimetext is not installed, skipping configuration"
        return 0
    esac
  fi

  if ! command -v subl && ! grep -q "${subl_dir}" $HOME/.profile
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
  quiet pushd sublime
  for settings in ./*.sublime-settings
  do
    cp "$settings" "${user_dir}/${settings}"
  done
  cp sublime-keymap "$user_keymap"
  quiet popd
}

install_vim()
{
  # vim itself
  if ! command -v vim
  then
    case $OSTYPE in
      darwin*)
        error "Install macvim according to: https://github.com/Valloric/YouCompleteMe#mac-os-x"
        ;;
      *)
        $here/scripts/pkg_install.sh vim
        ;;
    esac
  fi

  # tools needed
  $here/scripts/pkg_install.sh git cmake
  $here/scripts/g++_install.sh

  # the ~/.vim file has a line to autoload pathogen, which will autoload all plugins
  # that we install to ~/.vim/bundle
  # so we install pathogen, and some plugins, there
  mkdir -p $HOME/.vim/bundle
  quiet pushd $HOME/.vim/bundle
  echo "Installing vim plugins to `pwd`"

  # vim-pathogen
  clone_update git://github.com/tpope/vim-pathogen.git

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

  # vim-markdown
  clone_update git://github.com/plasticboy/vim-markdown.git

  # YouCompleteMe requires an install step, which takes a long time
  clone_update git://github.com/Valloric/YouCompleteMe.git
  CLANG='--clang-completer'
  NODE='--tern-completer'
  GOLANG='--gocode-completer'
  if ! [ -f YouCompleteMe/third_party/ycmd/ycm_core.so ]
  then
    echo "Installing YouCompleteMe"
    quiet pushd YouCompleteMe
    ./install.py $CLANG $NODE $GOLANG >/dev/null
    quiet popd
  fi

  quiet popd
}

install_node()
{
  if ! command -v nvm
  then
    info "installing nvm"
    quiet $here/scripts/nvm_install.sh
  fi
  if ! command -v yarn
  then
    info "installing yarn"
    quiet $here/scripts/yarn_install.sh
  fi

  source ~/.profile
  if ! command -v node
  then
    if ! nvm use --lts
    then
      nvm install --lts
    fi
  fi
}

install_go()
{
  if ! command -v go
  then
    info "installing golang"
    $here/scripts/go_install.sh
  fi
}

install_python()
{
  # install conda for python environments
  $here/scripts/miniconda_install.sh
}

install_tools()
{
  if ! command -v cfssl
  then
    $here/scripts/cfssl_install.sh
  fi

  # mycli is a mysql command line interface with smart tab completion
  pip install mycli
}

disable_unwanted_devices()
{
  case "$OSTYPE" in
    linux*)
      for rule in init/linux/udev/rules.d/*
      do
        sudo ln -s $(readlink -f "$rule") /etc/udev/rules.d/
      done
      # must reload the udev rules after installing new ones
      sudo udevadm control --reload-rules
      # tip: `udevadm monitor` can help debug rules
      ;;
  esac
}

# install everything, if we are not being sourced
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  install_deps
  install_dotfiles
  install_goodies
  # are we in a graphical session? if so, install sublimetext
  case "$OSTYPE" in
    linux*)
      if ! [ -z ${XDG_CURRENT_DESKTOP+x} ]
      then
        install_sublimetext
      else
        echo "non-graphical session (XDG_CURRENT_DESKTOP not defined), skipping sublimetext"
      fi
  esac
  install_node
  install_go
  install_vim
  install_python
  source ~/.profile
  install_tools
fi
