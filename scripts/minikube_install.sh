#!/usr/bin/env bash
#
# install minikube according to directions at

set -o errexit

info() {
  echo "`basename $0`: $*"
}

error() {
  echo >&2 "$*"
  exit 1
}

command -v kubectl &>/dev/null || error "kubectl required to install minikube"

release='v0.24.1'

case $OSTYPE in
  linux*)  platform='linux';;
  darwin*) platform='darwin';;
  *)       error "Platform '$OSTYPE' is not supported yet";;
esac

# download minikube and install to /usr/local/bin
curl -Lo minikube https://storage.googleapis.com/minikube/releases/"$release"/minikube-"$platform"-amd64 
chmod +x minikube 
sudo mv minikube /usr/local/bin/

# check whether virtualization is possible, and set `vm-driver` to `none` if not
case $platform in
  linux)
    if ! grep -m 1 '^flags' /proc/cpuinfo | grep -q -Eo 'vmx|svm'
    then
      # the CPU is not capable of virtualization (common on cloud VMs)
      # so let's run minikube on localhost instead of virtualbox (the default)
      cpu=$(awk -F: '/^model name/ { print $2; exit 0 }' </proc/cpuinfo)
      info "Your CPU (${cpu}) does not support virutalization, setting \`vm-driver\` to none"
      minikube config set vm-driver none
    else
      # the kvm-ok tool comes from the cpu-checker Ubuntu package
      if [[ $(source /etc/os-release; echo $ID) = ubuntu ]]
      then
        command -v kvm-ok >/dev/null 2>&1 || $here/scripts/pkg_install.sh cpu-checker
        if ! kvm-ok
        then
          info "virtualization is supported by the CPU, but not enabled in the BIOS. Settings \`vm-driver\` to none"
          minikube config set vm-driver none
        fi
      fi
    fi
    ;;
  darwin) error 'not sure how to set `vm-driver` on macos yet';;
  *)      error "impossible, did you add platform=${platform} above?";;
esac

# turn off this error prompting thingy
minikube config set WantReportErrorPrompt false
