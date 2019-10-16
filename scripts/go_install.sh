#!/usr/bin/env bash
#
# binary package installation instructions from https://golang.org/doc/install

set -o errexit

version='1.13.1'
case $OSTYPE in
  darwin*) platform='darwin';;
  linux*)  platform='linux';;
  *)
    echo >&2 "cannot install Golang for OS $OSTYPE}. See https://golang.org/doc/install"
    ;;
esac
url_targz="https://storage.googleapis.com/golang/go${version}.${platform}-amd64.tar.gz"

SILENT=${SILENT:=1}
((!SILENT)) && set -o xtrace

info() {
  echo "golang install: $*"
}

become_root() {
  if ! [ $EUID -eq 0 ]
  then
    if [ -f /etc/os-release ] && [[ $(source /etc/os-release; echo $ID) = ubuntu ]]
    then
      PRESERVE_ENV='-E'
    fi
    exec sudo $PRESERVE_ENV /bin/bash "$0" "$@"
  fi
}


# if we are being sourced, nothing below here will run
if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then return 0; fi

become_root

info "downloading ${url_targz}"
((SILENT)) && quiet='-q' || quiet='--show-progress'
wget "$quiet" "$url_targz"

tar -C /usr/local -xzf $(basename "$url_targz")
rm $(basename "$url_targz")

gopath_comment='set up Go workspace'
if ! grep -q "$gopath_comment" ~/.profile
then
  info 'Adding GOPATH env var'
  cat <<GOPATH >> ~/.profile

# ${gopath_comment}
if ! [ -d \$HOME/go ]
then
  mkdir -p \$HOME/go
fi
export GOPATH=\$HOME/go
GOPATH

fi

go_comment='install golang path'
if ! grep -q "$go_comment" ~/.profile
then
  info 'Adding golang to PATH'
  cat <<GO >> ~/.profile

# ${go_comment}
if [ -d /usr/local/go/bin ]
then
  export PATH="\$PATH:/usr/local/go/bin:\$GOPATH/bin"
fi
GO

fi

info 'Golang installation complete! Try `source ~/.profile` and `go version`'
