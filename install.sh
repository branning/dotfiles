#!/bin/bash
#
# Link all the regular files in dotfiles/home/ into ~, with a '.' prefix
#
# For example, dotfiles/home/profile --> ~/.profile
#              dotfiles/home/tmux    --> ~/.tmux

#set -o xtrace

# ye olde toole shoppe
library='
  info
  quiet
  clone_update
  '
for tool in $library
do
  here=$(cd $(dirname ${BASH_SOURCE[0]}); echo $PWD)
  source "${here}/library/${tool}.sh"
done

# once more, with feeling
here=$(cd $(dirname ${BASH_SOURCE[0]}); echo $PWD)

error() {
  echo "$(basename ${BASH_SOURCE[0]}) error: $*" >&2
  exit 1
}

install_bash()
{
  # use Bash as default shell
  if [ "$SHELL" != '/bin/bash' ]; then
    chsh -s /bin/bash
    exec -l /bin/bash
  fi
}

install_deps()
{
  for pkg in git curl jq
  do
    info "installing dependency: ${pkg}"
    "$here/scripts/pkg_install.sh" "$pkg"
  done
}

install_dotfiles()
{
  quiet pushd $here/home
  local symbolic # whether to make symlinmks. systemd hates them!

  echo "Linking files from $here/home into $HOME"
  for file in $(find * -maxdepth 0 -type f); do
    [[ -d $(dirname $file) ]] && symbolic='-s' || symbolic=''
    mkdir -p "$(dirname ~/."$file")"
    ln -v -f "$symbolic" "$PWD/$file" ~/."$file"
  done
  quiet popd
}

install_bash_completion()
{
  # Install base bash-completion with fewer bugs
  "$here/scripts/bash_completion.sh"

  # Install other Bash completions we have collected
  for completion_script in "$here"/scripts/bash_completion.d/*.sh
  do
    "$completion_script"
  done
}

install_aliases()
{
  # Curtis Allen's kctx trick
  "$here/scripts/kctx.sh"
}

install_lscolors()
{
  # LS_COLORS is used by readline when `set colored-stats on` is set
  # grab about 300 different colors for different filetypes
  "$here/scripts/lscolors_install.sh"
}

install_prompt()
{
  # an informative git prompt for Bash
  "$here/scripts/gitprompt_install.sh"
}

install_fonts()
{
  # firacode, fixed-width coding font with ligatures
  "$here/scripts/firacode_font_install.sh"
  case $OSTYPE in
    darwin*)
      open "$here/init/darwin/Big Ol Code.terminal"
      sudo -u "$USER" defaults write com.apple.Terminal.plist "Default Window Settings" "Big Ol Code"
      sudo -u "$USER" defaults write com.apple.Terminal.plist "Startup Window Settings" "Big Ol Code"
      ;;
    *)
      ;;
  esac
}

configure_git_ssh_keysigning()
{
  git config --global gpg.format ssh
  # shellcheck disable=SC2088
  git config --global user.signingkey '~/.ssh/id_1password.pub'
}

configure_git()
{
  configure_git_ssh_keysigning

  # show word differences in markdown (*.md) files when you run `git diff`
  "$here/scripts/git_markdown_word_diff.sh"
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
      bin_path=/usr/bin
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

  if ! command -v subl && ! grep -q "${subl_dir}" "$HOME/.profile"
  then
    echo "Adding Sublime Text bin dir to PATH: ${subl_dir}"
    export PATH="$PATH:${bin_path}"
    cat  <<EOF >>"$HOME/.profile"

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
  if ! command -v vim &>/dev/null || ! grep -q "+python3" <(vim --version)
  then
    case $OSTYPE in
      darwin*)
        "$here/scripts/pkg_install.sh" cmake macvim
        #error "Install macvim according to: https://github.com/ycm-core/YouCompleteMe#macos"
        ;;
      *)
        # Debian has vim with python plugin support in vim-nox package
        vim='vim'
        if os_id=$(source /etc/os-release; echo $ID) && [[ "$os_id" = debian ]]
        then
          vim='vim-nox'
        fi
        "$here/scripts/pkg_install.sh" $vim
        if ! grep -q "+python3" <(vim --version)
        then
           error "vim missing python3 plugin support. Install vim according to: https://github.com/Valloric/YouCompleteMe/wiki/Building-Vim-from-source"
        fi
        ;;
    esac
  fi

  # tools needed
  "$here/scripts/pkg_install.sh" git cmake
  "$here/scripts/g++_install.sh"

  # the ~/.vim file has a line to autoload pathogen, which will autoload all plugins
  # that we install to ~/.vim/bundle
  # so we install pathogen, and some plugins, there
  mkdir -p "$HOME/.vim/bundle"
  quiet pushd "$HOME/.vim/bundle"
  echo "Installing vim plugins to $PWD"

  # vim-pathogen
  clone_update git://github.com/tpope/vim-pathogen.git

  # neovim support for pathogen
  if command -v nvim
  then
    pathogen_autoload=~/.vim/bundle/vim-pathogen/autoload/pathogen.vim
    mkdir -p $(basename "$pathogen_autoload")
    ln -s "$pathogen_autoload" /usr/share/nvim/runtime/pathogen.vim
  fi

  # vim-fugitive requires a config step
  clone_update git://github.com/tpope/vim-fugitive.git
  vim -u NONE -c "helptags vim-fugitive/doc" -c q

  # vim-markdown
  clone_update git://github.com/plasticboy/vim-markdown.git

  # vim-javscript, for better ES6 highlighting
  clone_update git://github.com/pangloss/vim-javascript.git

  # vim-gitgutter, show git diff in gutter (left-most column)
  clone_update git://github.com/airblade/vim-gitgutter.git
  quiet popd

  # YouCompleteMe programmatic text completion
  # $here/scripts/youcompleteme_install.sh
}

install_editors()
{
  install_vim
  "$here/scripts/joplin_install.sh"
}

install_node()
{
  if ! command -v nvm
  then
    info "installing nvm"
    quiet "$here/scripts/nvm_install.sh"
  fi
  if ! command -v yarn
  then
    info "installing yarn"
    quiet "$here/scripts/yarn_install.sh"
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
    "$here/scripts/go_install.sh"
  fi
}

install_python()
{
  # install conda for python environments
  "$here/scripts/miniconda_install.sh"
}

install_tools()
{
  if ! command -v cfssl
  then
    "$here/scripts/cfssl_install.sh"
  fi

  # mycli is a mysql command line interface with smart tab completion
  pip install mycli

  # git lfs (large file support) is used to store references to huge files
  "$here/scripts/gitlfs_install.sh"
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
  install_bash
  install_deps
  install_dotfiles
  install_bash_completion
  install_aliases
  install_lscolors
  install_prompt
  install_fonts
  configure_git
  # are we in a graphical session? if so, install sublimetext and rescuetime
  case "$OSTYPE" in
    linux*)
      if ! [ -z ${XDG_CURRENT_DESKTOP+x} ]
      then
        install_sublimetext
        "$here/scripts/rescuetime_setup.sh"
      else
        echo "non-graphical session (XDG_CURRENT_DESKTOP not defined), skipping sublimetext and rescuetime"
        "$here/scripts/pkg_install.sh" ranger
      fi
  esac
  install_node
  install_go
  install_editors
  # install_python
  source ~/.profile
  install_tools
fi
