#!/usr/bin/env bash
#
# Install gradle and add to the path

set -o errexit
set -o pipefail
#set -o xtrace

version='4.2.1'
url_zip="https://services.gradle.org/distributions/gradle-${version}-bin.zip"
zip_file=`basename ${url_zip}`

error() {
  echo "`basename $0` error: $*" >&2
  exit 1
}

check_dep() {
  local dep=$1
  if ! command -v "$dep" &>/dev/null
  then
    error "the program '${dep}' is required and missing"
  fi
}

become_root() {
  if ! [ $EUID -eq 0 ]
  then
    exec sudo /bin/bash "$0" "$@"
  fi
}

# if we are being sourced, nothing below here will run
if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then return 0; fi

check_dep wget
become_root

gradle_install="/opt/gradle-${version}"
if [ -d "$gradle_install" ]
then
  echo "gradle version ${version} already exists at ${gradle_install}"
else
  wget -q "$url_zip"
  mkdir -p "$gradle_install"
  unzip -d /opt "$zip_file"
  rm "$zip_file"
fi

ln -vfs "${gradle_install}/" /opt/gradle
ln -vfs /opt/gradle/bin/gradle /usr/local/bin

