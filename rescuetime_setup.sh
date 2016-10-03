#!/bin/bash
#
# setup and enable Rescuetime service

is_lingering()
{
  [ yes = $(loginctl show-user ${USER} | awk -F= '/^Linger/ { print $2 }') ]
}

install_deps()
{
  needs='
    sqlite3
    gtk2-engines-pixbuf
    '
  sudo apt-get install ${needs} -y
}

install_rescuetime()
{
  deb=`mktemp rescuetime.XXXXX.deb`
  latest_url=https://www.rescuetime.com/installers/rescuetime_current_amd64.deb
  wget -O $deb $latest_url
  install_deps
  dpkg -i $deb
  rm $deb
}


# if we are being sourced, nothing below here will run
if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then return 0; fi

if ! dpkg -l | grep -q rescuetime
then
  install_rescuetime
fi

if ! is_lingering
then
  sudo loginctl enable-linger ${USER}
fi

systemctl --user daemon-reload

if ! systemctl --user is-enabled rescuetime.service >/dev/null
then
  systemctl --user enable rescuetime.service
fi

if ! systemctl --user status rescuetime.service --no-pager >/dev/null
then
  systemctl --user start rescuetime.service
fi

