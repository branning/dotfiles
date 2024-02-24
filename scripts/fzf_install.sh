#!/usr/bin/env bash
#
# Install command line fuzzy finder (fzf) from Github

# ye olde toole shoppe
library='
  info
  quiet
  '
for tool in $library
do
  here=$(cd "$(dirname "${BASH_SOURCE[0]}")" || exit; echo "$PWD")
  source "${here}/../library/${tool}.sh"
done
here=$(cd "$(dirname "${BASH_SOURCE[0]}")" || exit; echo "$PWD")

if ! command -v fzf >/dev/null 2>&1
then
  if ! [ -d ~/.fzf ]
  then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  else
    quiet pushd ~/.fzf
    quiet git pull
    quiet popd
  fi
  info "installing fzf"
  quiet ~/.fzf/install --all
fi
