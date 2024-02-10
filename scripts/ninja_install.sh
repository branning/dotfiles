#!/usr/bin/env bash
#
# install Ninja build tool binary release from Github
# see https://github.com/ninja-build/ninja/releases for latest

latest_ninja()
{
  # returns true if the latest ninja is installed
  latest='1.11.1'
  # sort the desired and actual versions. if the lower of the two is the same
  # as the latest, then the installed version is equal or greater than latest
  lower=$(printf "${latest}\n`ninja --version`\n" | sort -V | head -n 1)
  [[ "$lower" = "$latest" ]]
}

install_ninja()
{
  case $OSTYPE in
    darwin*) os='mac';;
    win*)    os='win';;
    linux*)  os='linux';;
    *)       echo >&2 "unsupported OS: $OSTYPE"; exit 1;;
  esac
  url="https://github.com/ninja-build/ninja/releases/download/v1.8.2/ninja-${os}.zip"
  wget "$url"
  unzip $(basename ${url})
  mkdir -p ~/bin
  mv ./ninja ~/bin/
  rm $(basename ${url})
}

# install ninja if we were executed
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  if latest_ninja
  then
    echo "ninja `ninja --version` already installed"
  else
    install_ninja
  fi
fi
