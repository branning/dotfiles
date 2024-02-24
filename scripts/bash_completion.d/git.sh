#!/usr/bin/env bash
#
# Install git Bash completion

here=$(cd "$(dirname "${BASH_SOURCE[0]}")" || exit; echo "$PWD")

git_comment='install git bash completion'
if ! grep -q "$git_comment" ~/.profile
then
  echo 'Installing git Bash completion'
  completion_url='https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash'
  $here/../pkg_install.sh curl
  curl -s "$completion_url" -o "$here/../git-completion.bash"
  cat <<GIT >> ~/.profile

# ${git_comment}
if [ -n "\$BASH_VERSION" ]
then
  source $here/../git-completion.bash
fi
GIT
fi
