#!/bin/bash
#
# Install conda
# modified from https://github.com/blaze/odo/blob/master/.travis.yml

miniconda_home=$HOME/miniconda

install_latest()
{
  wget http://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda3.sh
  bash miniconda3.sh -b -p ${miniconda_home}
  rm miniconda3.sh
}

install_path()
{
  # install miniconda to PATH
  if ! grep -q miniconda $HOME/.profile
  then
    cat <<EOF >>$HOME/.profile

# add conda to path
if [ -d ${miniconda_home} ]
then
    PATH="\$PATH:${miniconda_home}/bin"
fi
EOF
  fi
  source $HOME/.profile
}

# if conda is not on the path, put it there
# if it's still not on the path, install it
if ! command -v conda
then
  install_path
  if ! command -v conda
  then
    install_latest
    source $HOME/.profile
  fi
fi

conda config --set always_yes yes --set changeps1 no
conda update conda
