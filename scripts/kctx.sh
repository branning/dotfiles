#!/usr/bin/env bash
#
# Curtis Allen's kctx trick: https://asciinema.org/a/dltaxEgFpmTzHp4ihhEtZLAKX
#
# Install a Bash alias to select a kubernetes context from a list

set -o errexit

here=$(cd $(dirname $BASH_SOURCE); echo $PWD)

# install fzf
"$here/fzf_install.sh"

kctx_comment="Curtis Allen's kctx trick: https://asciinema.org/a/dltaxEgFpmTzHp4ihhEtZLAKX"
if ! grep -q "$kctx_comment" ~/.bash_aliases
then
  echo 'Installing kctx to ~/.bash_aliases'
  cat <<KCTX >> ~/.bash_aliases

# ${kctx_comment}
alias kctx='kubectl config use-context \$(kubectl config get-contexts -o=name | fzf)'
KCTX
fi
