## Spaces not tabs

To set 2-space indentation, press <kbd>:</kbd> to enter command mode, then type:

    set tabstop=2 shiftwidth=2 expandtab

## Trim trailing whitespace

    :%s/\s\+$//e

## Replace tabs

Follow the [step above](#spaces-not-tabs), then

    :retab

## To comment out blocks in vim: ##

from https://stackoverflow.com/a/15588798/347567 on 4/2/2018

- press <kbd>Esc</kbd> (to leave editing or other mode)
- hit <kbd>ctrl</kbd>+<kbd>v</kbd> (visual block mode)
- use the up/down arrow keys to select lines you want (it won't highlight everything - it's OK!)
- <kbd>Shift</kbd>+<kbd>i</kbd> (capital I)
- insert the text you want, i.e. `% `
- press <kbd>Esc</kbd><kbd>Esc</kbd>

----------

## To uncomment blocks in vim: ##

- press <kbd>Esc</kbd> (to leave editing or other mode)
- hit <kbd>ctrl</kbd>+<kbd>v</kbd> (visual block mode)
- use the <kbd>↑</kbd>/<kbd>↓</kbd> arrow keys to select the lines to uncomment.
> *If you want to select multiple characters, use one or combine these methods:*
> - *use the left/right arrow keys to select more text*
> - *to select chunks of text use <kbd>shift</kbd> + <kbd>←</kbd>/<kbd>→</kbd> arrow key*
> - *you can repeatedly push the delete keys below, like a regular delete button*
- press <kbd>d</kbd> or <kbd>x</kbd> to delete characters, repeatedly if necessary

## Write with sudo trick

    :w !sudo tee %
