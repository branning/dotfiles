## reset submodule and discard changes

    git submodule update --init

## compare two files outside of repository

    git diff --no-index file1.txt file2.txt

## change list of files versus master

Compare current branch against `master` branch:

    git diff --name-status master

Compare any two branches:

    git diff --name-status firstbranch..secondbranch

https://stackoverflow.com/a/822859

## delete merged branches

Be sure to avoid deleting your local develop or master branches. It's not a big
deal if you do, you can fetch them again, and `branch -d` should refuse to
delete them if they're dirty.

    git branch --merged | grep -vE '(master|develop)' | xargs git branch -d

## list commits that are different from master

    git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative ${MASTER}..${MY_FEATURE_BRANCH}

## git checkout with submodules

    git clone --recurse-submodules -j8 git://github.com/branning/cantrips.git

## checkout submodules in already cloned repos

    git submodule update --init --recursive

## get top level directory from anywhere in the tree

    git rev-parse --show-toplevel

## git push fails with zeroPaddedFilemode error

If upon pushing to a remote repo you get an error like this

    remote: error: object 7a80ca084167b04a732640a2f18ec86af55377fb: zeroPaddedFilemode: contains zero-padded file modes

then there is probably a corrupt file in the Git object database. To confirm that, run

    git fsck

which should report the same problem, like this

> Checking object directories: 100% (256/256), done.
> warning in tree 7a80ca084167b04a732640a2f18ec86af55377fb: zeroPaddedFilemode: contains zero-padded file modes
> Checking objects: 100% (8822/8822), done.

We are going to make a new repo, export the old one and import it again and in the process fix our file(sytem?) error.

    mkdir ~/myrepo-new
    cd ~/myrepo-new
    git init

    cd ~/myrepo
    git fast-export --all | (cd ~/myrepo-new/ && git fast-import)

Upon doing that, you should no longer see any warnings or errors from `git fsck`:

> ✔ philip:novnc-new [ master ✭ | ● 173 ] ➭ git fsck
> Checking object directories: 100% (256/256), done.
> Checking objects: 100% (8847/8847), done.
