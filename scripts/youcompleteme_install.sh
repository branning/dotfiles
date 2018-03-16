#!/usr/bin/env bash
#
# Install YouCompleteMe text completion plugin for Vim and language tools for
#  - C++
#  - Node
#  - Go

# ye olde toole shoppe
library='
  info
  quiet
  clone_update
  '
for tool in $library
do
  here=$(cd $(dirname $BASH_SOURCE[0]); echo $PWD)
  source "${here}/../library/${tool}.sh"
done

# once more, with feeling
here=$(cd $(dirname $BASH_SOURCE[0]); echo $PWD)

# vim plugins go here
mkdir -p $HOME/.vim/bundle
quiet pushd $HOME/.vim/bundle
echo "Installing vim plugins to `pwd`"

# YouCompleteMe repo has submodules
clone_update git://github.com/Valloric/YouCompleteMe.git
CLANG='--clang-completer'
NODE='--tern-completer'
GOLANG='--gocode-completer'
# YouCompleteMe requires an install step, which takes a long time
if ! [ -f YouCompleteMe/third_party/ycmd/ycm_core.so ]
then
  info "Installing YouCompleteMe"
  quiet pushd YouCompleteMe
  ./install.py $CLANG $NODE $GOLANG >/dev/null
  quiet popd
fi

popd # plugin directory
