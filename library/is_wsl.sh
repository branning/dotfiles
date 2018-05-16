#!/usr/bin/env bash
#
# detect if we are running Bash on Ubuntu under Windows Subsystem for Linux
# on Windows Subsystem for Linux Ubuntu, use Docker for Windows

# must check /proc/version for both "Microsoft" and "WSL"
# see https://stackoverflow.com/a/43618657/347567
is_wsl()
{
  grep -qE "(Microsoft|WSL)" /proc/version >/dev/null 2>&1
}
