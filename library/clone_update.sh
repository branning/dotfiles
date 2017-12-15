#!/usr/bin/env bash

here=$(cd $(dirname $BASH_SOURCE[0]); echo $PWD)
source "$here/quiet.sh"

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
  if command -v nproc >/dev/null 2>&1
  then
    parallel="--jobs $(nproc)"
  fi
  git submodule update --init --recursive "$parallel"
  quiet popd
}

git_clean()
{
    if quiet git diff --exit-code && quiet git diff --cached --exit-code
    then return 0
    else return 1
    fi
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

