#!/usr/bin/env bash
#
# tell Git to always use word-diff on markdown files

# The question of whether to hard-break long lines in source code files evokes strong opinions from the hard-80-column crowd and the laissez-faire soft-wrappers. The differences in ergonomics mostly boil down to text editor capabilities. Having a soft-break at line 80 seems ideal. Editing a file of sentences that have artifically been broken at line 80 is aggravating, but only if you can't easily rewrap the paragraph of text. Vim and Emacs users seem to prefer hard-wrapping, and may have difficulty in soft-wrapping, particularly around line navigation in Vim, but have quick rewrapping routines as a result. SublimeText and other graphical mode editors have very nice soft-wrapping, including a sane way to move to a previous line of text within a soft-wrapped line, but re-wrapping paragraphs may be difficult.
#
# Regardless, source control tooling also favors shorter lines for seeing differences. A long paragraph, like above, with a isingle difference, will always appear as if the entire line as changed, which can make spotting the difference a word hunt. Git supports different diff tools per filetype, and this script installs confguration to use `word-diff` for markdown (*.md) files.

here=$(cd $(dirname $BASH_SOURCE[0]); echo $PWD)

case $1 in
  uninstall)
    git config --global --unset core.attributesfile
    git config --global --remove-section diff.markdown
    echo "uninstalled git diff markdown word driver"
    exit 0
    ;;
  *) ;; # let's go ahead and install
esac

# find out where our attributes file is
gitattributes=~/.gitattributes
diffdriver=$here/git-word-diff-driver

if ! git config --get core.attributesfile >/dev/null
then
  # tell git to use ~/.gitattributes
  # see https://git-scm.com/docs/gitattributes
  git config --global core.attributesfile ~/.gitattributes
fi

if ! git config --get diff.markdown.command >/dev/null
then
  # tell git how we should diff markdown files
  git config --global diff.markdown.command $diffdriver
fi

# this should exist, but just in case
if ! [ -f "$diffdriver" ]
then
  cat <<'EOF' > $diffdriver
#!/bin/sh
#
# from https://stackoverflow.com/a/36368222/347567

# args to this script are:
# path old-file old-hex old-mode new-file new-hex new-mode

git diff --word-diff $2 $5

exit 0
EOF
fi

# we should have linked ~/.gitattributes -> home/gitattributes, but just in case
if ! [ -f "$gitattributes" ]
then
  cat <<EOF > $gitattributes
*.md	diff=markdown
EOF
fi
