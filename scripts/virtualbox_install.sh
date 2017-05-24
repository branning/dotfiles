#!/bin/bash
#
# install virtualbox on Ubuntu 16.04

set -o errexit

# provides DISTRIB_RELEASE and DISTRIB_CODENAME
source /etc/lsb-release

cat <<EOF | sudo tee /etc/apt/sources.list.d/virtualbox.list
# from https://www.virtualbox.org/wiki/Linux_Downloads#Debian-basedLinuxdistributions
deb http://download.virtualbox.org/virtualbox/debian ${DISTRIB_CODENAME} contrib
EOF

# Oracle public key for apt-secure
if (( ${DISTRIB_RELEASE//./} < 1604 ))
then
  wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
else
  wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
fi

# update and install
sudo apt-get update
sudo apt-get install virtualbox-5.1 -y
