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

here=$(cd $(dirname $BASH_SOURCE); echo $PWD)
workdir=$(mktemp -d)
trap "cd $here; rm -rf $workdir" EXIT

cd "$workdir"
mkdir bash-completion
cd bash-completion/

# setup sparse checkout of only the `bash_completion` file from master branch
git init
git remote add origin git://git.debian.org/git/bash-completion/bash-completion.git
git config core.sparseCheckout true
cat <<'EOF' > .git/info/sparse-checkout
bash_completion
completions/*
helpers/*
EOF

git pull origin master
sudo cp -rf * /usr/share/bash-completion/
exit 0
