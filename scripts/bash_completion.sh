#!/usr/bin/env bash
#
# Ubuntu Bash completion has a bug related to completion inside of command
# expansion. See https://alioth.debian.org/tracker/?func=detail&aid=314667&group_id=100114&atid=413095
#
# As recommended on AskUbuntu (https://askubuntu.com/a/576983/541707), get the
# newest bash-completion from git. We'll just do this all the time, regardless
# of whether we're on Ubuntu or not.

set -o errexit
#set -o xtrace

become_root() {
  if ! [ $EUID -eq 0 ]
  then
    [[ $(source /etc/os-release; echo $ID) = ubuntu ]] && PRESERVE_ENV='-E'
    exec sudo "$PRESERVE_ENV" /bin/bash "$0" "$@"
  fi
}

# if we are being sourced, nothing below here will run
if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then return 0; fi

#become_root

here=$(cd "$(dirname "${BASH_SOURCE[0]}")" || exit; echo "$PWD")
trap "cd $here" EXIT

workdir=$HOME/src/bash-completion
mkdir -p "$workdir"
cd "$workdir"

# setup sparse checkout of only the `bash_completion` file from master branch
debian_repo='git://git.debian.org/git/bash-completion/bash-completion.git'
if ! git status >/dev/null 2>&1
then
  git init >/dev/null 2>&1
  git remote add origin "$debian_repo"
fi
git config core.sparseCheckout true
cat <<'EOF' > .git/info/sparse-checkout
bash_completion
completions/*
helpers/*
EOF

echo "`basename $0`: cloning repo from ${debian_repo}"

git pull origin master >/dev/null 2>&1
sudo cp -rf * /usr/share/bash-completion/
