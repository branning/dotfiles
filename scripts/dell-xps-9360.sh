#!/usr/bin/env bash
#
# Hardware-specific fixes for Dell XPS 13 9360 laptop

set -o errexit
set -o pipefail

here=$(cd $(dirname $BASH_SOURCE); echo $PWD)

is_dell_xps() {
  dmidecode -t 1 | grep -q 'XPS 13 9360'
}

become_root() {
  if ! [ $EUID -eq 0 ]
  then
    exec sudo /bin/bash "$0" "$@"
  fi
}

blacklist_psmouse() {
# from http://en.community.dell.com/techcenter/os-applications/f/4613/t/19992924
# the OS detects two touchpads, can be seen in `xinput --list`
#⎡ Virtual core pointer                        id=2    [master pointer  (3)]
#⎜   ↳ Virtual core XTEST pointer                  id=4    [slave  pointer  (2)]
#⎜   ↳ ELAN Touchscreen                            id=10    [slave  pointer  (2)]
#⎜   ↳ DLL0704:01 06CB:76AE Touchpad               id=12    [slave  pointer  (2)]
#⎜   ↳ SynPS/2 Synaptics TouchPad                  id=14    [slave  pointer  (2)]
# one of them comes up as a PS/2 mouse. In order to regain sanity, blacklist it.
# see http://en.community.dell.com/support-forums/laptop/f/3518/p/19996875/20958143#20958143
  ln -v -f "$here/../config/etc/modprobe.d/xps13-9360.conf" \
           /etc/modprobe.d/xps13-9360.conf
  update-initramfs -u
}

install_libinput(){
  # remove synaptics and use libinput + libgestures intead
  # see https://www.reddit.com/r/Dell/comments/646y0t/xps_9560_setting_up_multitouch_gestures_with/
  apt remove xserver-xorg-input-synaptics-hwe-16.04
  apt install xserver-xorg-input-libinput-hwe-16.04
  # install the configuration file for:
  #   natural scrolling
  #   tap to click
  #   pointer acceleration
  #   palm detection
  ln -f -f "$here/../config/usr/share/X11/xorg.conf.d/40-libinput.conf" \
           /usr/share/X11/xorg.conf.d/40-libinput.conf

  # install libgestures from github
  git clone http://github.com/bulletmark/libinput-gestures
  pushd libinput-gestures
  make install
  popd
  rm -rf libinput-gestures

  # libgestures needs libinput-tools and xdotool
  apt install libinput-tools xdotool

  # the current user must be in the input group to allow reading touchpad device
  gpasswd -a $USER input

  # start libgestures automatically at boot
  libinput-gestures-setup autostart

  # install libgestures configuration file
  mkdir -p ~/.config
  ln -v -f "$here/../config/libinput-gestures.conf" \
           ~/.config/libinput-gestures.conf
}

# if we are being sourced, nothing below here will run
if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then return 0; fi

become_root

if ! is_dell_xps
then
  exit 0
fi

blacklist_psmouse
install_libinput
