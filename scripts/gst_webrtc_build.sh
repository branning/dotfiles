#!/usr/bin/env bash
#
# build Gstreamer's webrtc plugin, as well as Gstreamer
#
# includes script snippets from pioneer efforts of @nh2 from
# https://github.com/centricular/gstwebrtc-demos/issues/2

gst_build_repo='git://anongit.freedesktop.org/gstreamer/gst-build'

# 1. clone gst-build
# 2. ensure build tools are installed
#    - git
#    - meson
#    - ninja
# 2. ensure dependencies are installed
#    - libsrtp-dev
#    - libsoup-dev
#    - libjson-glib-dev
#    - libnice 1.14 (wget from freedesktop.org)
# 3. meson `mkdir build && meson build && ninja -C build`
# 4. build webrtc-sendrecv
# 5. run webrtc-sendrecv with library paths

# Needed deps on Ubuntu 16.04:
#
# libsoup2.4-dev
# libjson-glib-dev
install_deps()
{
  tools='
    git
    curl
    pkg-config
    flex
    bison
    '
  libs='
    libglib2.0-dev
    libsoup2.4-dev
    libjson-glib-dev
    libffi-dev
    libgnutls-dev
    libopus-dev
    libvpx-dev
    '
  for pkg in $tools $libs
  do
    echo "installing dependency: ${pkg}"
    $here/pkg_install.sh "$pkg"
  done
}

install_libnice()
{
  # required libnice '>=0.1.14' is not in apt
  sudo apt remove libnice-dev -y

  version='0.1.14'
  url="https://nice.freedesktop.org/releases/libnice-${version}.tar.gz"
  curl -O "$url"
  tar xaf $(basename ${url})
  cd "libnice-${version}"
  ./configure --prefix=$HOME/opt/libnice
  make -j`nproc` install
}


# if we are being sourced, nothing below here will run
if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then return 0; fi

set -euo pipefail

here=$(cd "$(dirname "${BASH_SOURCE[0]}")" || exit; echo "$PWD")

install_deps
install_libnice
$here/ninja_install.sh

set -o xtrace
pushd ~/gstwebrtc-demos/sendrecv/gst
gcc -O2 webrtc-sendrecv.c \
  $(PKG_CONFIG_PATH=$(find ~/gst-build/build -name pkgconfig -type d | tr '\n' :) pkg-config --cflags --libs gstreamer-webrtc-1.0 gstreamer-sdp-1.0 gstreamer-rtp-1.0 libsoup-2.4 json-glib-1.0) -o webrtc-sendrecv
