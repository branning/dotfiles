#!/usr/bin/env bash
#
# convert a Windows path like
#
#     C:\Users\luser1\Downloads\thatsthejoke.jpg
#
# to a WSL path like
#
#     /mnt/c/luser1/Downloads/thatsthejoke.jpg

win_path_to_wsl()
{
  tr '\r' '\n' | sed 's|^C:|/mnt/c|' | tr '\\' '/'
}
