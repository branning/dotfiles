## tmux notes

Prefix is Control+B by default, but I like GNU Screen's Control+A. Anywhere you see Ctrl+A, that's the prefix.

# open a new window

`Ctrl+A c`

# rename a window

* ^H is backspace

`Ctrl+a , ^H^H^H^H^H^H<new name>`

# realoading tmux config in a running session

`Ctrl+A :source-file ~/.tmux.conf`

