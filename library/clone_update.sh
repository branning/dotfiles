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

has_git_parallel()
{
  # git version 2.9 and later have '--jobs N' argument to git submodule update
  # of the desired version 2.9 and the installed version, which is lower
  lower=$(printf "2.9\n`git --version | awk '{print $3}'`\n" | sort -V | head -n 1)
  # if 2.9 is lower, then our version is 2.9 or greater and we are ok
  [[ "$lower" = 2.9 ]]
}

clone_deep()
{
  local giturl
  giturl="$1"
  git clone "$giturl" || return 1
  quiet pushd `reponame $giturl`
  if has_git_parallel && command -v nproc >/dev/null 2>&1
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

