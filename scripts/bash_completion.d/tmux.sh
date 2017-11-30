#!/usr/bin/env bash
#
# Install tmux bash completion

here=$(cd $(dirname $BASH_SOURCE[0]); echo $PWD)

# we used to put this in ~/.bash_profile, remove if found there
[ -f ~/.bash_profile ] && sed -ie '/bash_completion_tmux.sh/d' ~/.bash_profile

tmux_comment='install tmux bash completion'
if ! grep -q "$tmux_comment" ~/.profile
then
  echo 'Installing tmux Bash completion'
  cat <<TMUX >> ~/.profile

# ${tmux_comment}
if [ -n "\$BASH_VERSION" ]
then
  source $here/../bash_completion_tmux.sh
fi
TMUX
fi

