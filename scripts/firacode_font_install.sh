#!/usr/bin/env bash
#
# Install FiraCode programming font, see https://github.com/tonsky/FiraCode

case $OSTYPE in
  darwin*)
    if brew cask list | grep -q font-fira-code; then
      exit 0
    fi
    brew tap homebrew/cask-fonts
    brew cask install font-fira-code
    ;;

  win*)
    scoop bucket add nerd-fonts
    scoop install FiraCode
    ;;

  linux*)
    fonts_dir="${HOME}/.local/share/fonts"
    if [ ! -d "${fonts_dir}" ]; then
        echo "mkdir -p $fonts_dir"
        mkdir -p "${fonts_dir}"
    else
        echo "Found fonts dir $fonts_dir"
    fi

    for type in Bold Light Medium Regular Retina; do
        file_path="${HOME}/.local/share/fonts/FiraCode-${type}.ttf"
        file_url="https://github.com/tonsky/FiraCode/blob/master/distr/ttf/FiraCode-${type}.ttf?raw=true"
        if [ ! -e "${file_path}" ]; then
            echo "wget -O $file_path $file_url"
            wget -O "${file_path}" "${file_url}"
        else
      echo "Found existing file $file_path"
        fi;
    done

    echo "fc-cache -f"
    fc-cache -f
    ;;

  *)       echo >&2 "unsupported OS: $OSTYPE"; exit 1;;
esac
