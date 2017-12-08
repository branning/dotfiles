#!/usr/bin/env bash
#
# Install an informative git prompt for Bash
# from https://github.com/olivierverdier/zsh-git-prompt
# port of informative git prompt for zsh: https://github.com/olivierverdier/zsh-git-prompt

set -o errexit

here=$(cd $(dirname $BASH_SOURCE[0]); echo $PWD)
source "$here/../library/clone_update.sh"

clone_update https://github.com/magicmonty/bash-git-prompt.git $HOME/.bash-git-prompt --depth=1

gitcolors_comment='Install an informative git prompt for Bash'
if ! grep -q "$gitcolors_comment" ~/.bashrc
then
  cat <<EOF >> $HOME/.bashrc

# ${gitcolors_comment}
if [ -f \$HOME/.bash-git-prompt/gitprompt.sh ]
then
  GIT_PROMPT_ONLY_IN_REPO=1
  source \$HOME/.bash-git-prompt/gitprompt.sh
fi
EOF
fi
