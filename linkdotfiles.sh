#!/bin/bash

pushd home
for file in $(find *); do
  echo $file
  ln -fs dotfiles/home/$file ~/.$file
done
popd

