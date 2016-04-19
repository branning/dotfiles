#!/bin/bash

pushd $(dirname `readlink -f $0`)/home || exit 0
for file in $(find *); do
  echo $file
  ln -fs $PWD/$file ~/.$file
done
popd

