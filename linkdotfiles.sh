#!/bin/bash

pushd home
for file in $(find *); do
  echo $file
  ln -fs $PWD/$file ~/.$file
done
popd

