#!/usr/bin/env bash
#
# Install command line fuzzy finder (fzf) from Github

if ! command -v fzf >/dev/null 2>&1
then
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install
fi
