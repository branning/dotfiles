#!/usr/bin/env bash
#
# convert a WSL path like
#
#     /mnt/c/luser1/Downloads/thatsthejoke.jpg
#
# to a Windows path like
#
#     C:\Users\luser1\Downloads\thatsthejoke.jpg

wsl_path_to_win()
{
  sed 's|/mnt/c|C:|' | tr '/' '\\'
}
