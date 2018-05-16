#!/usr/bin/env bash
#
# use convenience script as described here:
# https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/#install-using-the-convenience-script

set -o errexit

wsl_docker_comment='on Windows Subsystem for Linux Ubuntu, use Docker for Windows'

here=$(cd $(dirname $BASH_SOURCE[0]); echo $PWD)
source "${here}/../library/is_wsl.sh" # provides is_wsl()

if is_wsl && ! grep -q "$wsl_docker_comment" ~/.profile
then
  echo "$wsl_docker_comment"
  cat <<WSL >> ~/.profile

# ${wsl_docker_comment}
if grep -qE "(Microsoft|WSL)" /proc/version >/dev/null 2>&1
then
    export DOCKER_HOST=tcp://127.0.0.1:2375
fi
WSL

fi

# install Docker using convenience script
trap 'rm -f get-docker.sh' EXIT
curl -fsSL get.docker.com -o get-docker.sh
sudo sh get-docker.sh
