#!/bin/bash
#
# Install and fixup basictex for use with knitr in RStudio

set -o errexit
set -o xtrace

error()
{
    echo "`basename $0` error: $@" 2>&1
    exit 1 
}

homebrew_hint()
{
    echo 'Try: /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"'
} 

find_tlmgr()
{
    find /usr/local/texlive -name tlmgr | tail -n 1
}

rmarkdown_deps()
{
    texlive_deps="
        collection-fontsrecommended 
        framed 
        titling
        "
    for dep in $texlive_deps
    do
        sudo $tlmgr install $dep
    done
}

# install basictex if we are not being sourced
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then

if ! command -v brew
then
    homebrew_hint
    error "homebrew is not installed"
fi

if ! brew list | grep -q basictex
then
    brew cask install basictex
fi

tlmgr=`find_tlmgr`
[ -x $tlmgr ] || error "Cannot find or execute tlmgr (at path $tlmgr)"

sudo $tlmgr update --self
rmarkdown_deps


fi # end main script
