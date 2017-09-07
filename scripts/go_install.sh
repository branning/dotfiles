#!/usr/bin/env bash
#
# binary package installation instructions from https://golang.org/doc/install

version='1.9'
url_targz="https://storage.googleapis.com/golang/go${version}.linux-amd64.tar.gz"

info() {
  echo "golang install: $*"
}

info "downloading ${url_targz}"
wget -q "$url_targz"
sudo tar -C /usr/local -xzf $(basename "$url_targz")
rm $(basename "$url_targz")

go_comment='install golang path'
if ! grep -q "$go_comment" ~/.profile
then
  info 'Adding golang to PATH'
  cat <<GO >> ~/.profile

# ${go_comment}
if [ -d /usr/local/go/bin ]
then
  export PATH="\$PATH:/usr/local/go/bin"
fi
GO

fi

