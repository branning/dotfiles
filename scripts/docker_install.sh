#!/usr/bin/env bash
#
# use convenience script as described here:
# https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/#install-using-the-convenience-script

set -o errexit

trap 'rm -f get-docker.sh' EXIT
curl -fsSL get.docker.com -o get-docker.sh
sudo sh get-docker.sh

