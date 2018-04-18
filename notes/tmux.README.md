## tmux notes

Prefix is <kbd>Ctrl</kbd>+<kbd>b</kbd> by default, but I like GNU Screen's <kbd>Ctrl</kbd>+<kbd>a</kbd>. Anywhere you see <kbd>Ctrl</kbd>+<kbd>a</kbd>, that's the prefix.

# open a new window

<kbd>Ctrl</kbd>+<kbd>a</kbd>, <kbd>c</kbd>

# rename a window

* ^H is backspace

<kbd>Ctrl</kbd>+<kbd>a</kbd>, <kbd>Ctrl</kbd>+<kbd>h</kbd>, <kbd>Ctrl</kbd>+<kbd>h</kbd>, <kbd>Ctrl</kbd>+<kbd>h</kbd>, <kbd>Ctrl</kbd>+<kbd>h</kbd>, <kbd>Ctrl</kbd>+<kbd>h</kbd>, <kbd>Ctrl</kbd>+<kbd>h</kbd>, `<new name>`

# reloading tmux config in a running session

<kbd>Ctrl</kbd>+<kbd>a</kbd>, `:source-file ~/.tmux.conf`

# unfreeze tmux

This seemed to work. I had been playing around with [panes](#panes) and the
screen stopped responding. Commands were still working, though, for instance
I could change windows, and a different window would be drawn, but none of
the commands were updating the screen.

see https://stackoverflow.com/a/47571736

<kbd>Ctrl</kbd>+<kbd>a</kbd>, `:choose-client`

Then choose any of the clients (why were there 2?) and tmux updates again.

# panes

## split pane vertically

<kbd>Ctrl</kbd>+<kbd>a</kbd>, `%`

## split pane horizontally

<kbd>Ctrl</kbd>+<kbd>a</kbd>, `"`

## close pane

<kbd>Ctrl</kbd>+<kbd>a</kbd>, `x`

## swap panes

<kbd>Ctrl</kbd>+<kbd>a</kbd>, `o`

or

<kbd>Ctrl</kbd>+<kbd>a</kbd>, `<left arrow>`
<kbd>Ctrl</kbd>+<kbd>a</kbd>, `<right arrow>`

Will select the left or right panes.

## select pane by number

<kbd>Ctrl</kbd>+<kbd>a</kbd>, `q`

Pane numbers will be superimposed on panes. Press a number to select the pane.

