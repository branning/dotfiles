#!/bin/bash
#
# Install conda
# modified from https://github.com/blaze/odo/blob/master/.travis.yml

miniconda_home=$HOME/miniconda

install_latest()
{
  echo "Installing latest Miniconda to ${miniconda_home}"
  ext='sh'
  case $OSTYPE in
    darwin*)    platform='MacOSX';;
    linux*)     platform='Linux';;
    win*)       platform='Windows'
                ext='exe';;
    *)          echo >&2 "Unknown platform ${OSTYPE}, cannot install miniconda"
                exit 1;;
  esac

  url="https://repo.continuum.io/miniconda/Miniconda3-latest-${platform}-x86_64.${ext}"
  wget --show-progress -nv "$url" -O miniconda3.sh
  rm -rf ${miniconda_home}
  bash miniconda3.sh -b -p ${miniconda_home}
  rm miniconda3.sh
}

install_path()
{
  # install code ~/.profile to add miniconda to PATH
  if ! grep -q miniconda $HOME/.profile
  then
    cat <<EOF >>$HOME/.profile

# add conda to path
if [ -d $HOME/miniconda ] && ! onpath $HOME/miniconda
then
    export PATH="${miniconda_home}/bin:\$PATH"
    conda config --set changeps1 yes
fi
EOF
  fi
  source $HOME/.profile
}

# install latest version of miniconda, if none found
if ! [ -x "$miniconda_home/bin/conda" ]
then
  install_latest
fi

# if conda is not on the path, put it there
if ! command -v conda
then
  install_path
fi

# this config step seems to be done already in `install_path`
#conda config --set always_yes yes

conda update conda -y -q
