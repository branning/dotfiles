#!/usr/bin/env bash
#
# Install pip Bash completion

pip_comment="pip bash completion start"
if ! grep -q "$pip_comment" ~/.profile
then

  if pip help completion >/dev/null 2>&1
  then
    pip completion --bash >> ~/.profile
  fi

fi
