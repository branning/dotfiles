#!/bin/bash
#

case "$1" in
  uninstall|remove)
    #Uninstall LaunchDaemon org.nixos.nix-daemon
    sudo launchctl bootout system/org.nixos.nix-daemon
    sudo rm -f /Library/LaunchDaemons/org.nixos.nix-daemon.plist

    # Delete the files Nix added to your system:
    sudo rm -rf "/etc/nix" "/var/root/.nix-profile" "/var/root/.nix-defexpr" "/var/root/.nix-channels" "/var/root/.local/state/nix" "/var/root/.cache/nix" "~/.nix-profile" "~/.nix-defexpr" "~/.nix-channels" "~/.local/state/nix" "~/.cache/nix"
    { mount | grep /nix; } && sudo umount /nix
    echo "Uninstalled Nix"
    ;;
  test)
    nix-shell -p nix-info --run "nix-info -m"
    ;;
  *|install)
    export NIX_FIRST_BUILD_UID=351
    sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --yes
    ;;
esac

