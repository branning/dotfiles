## git checkout with submodules

    git clone --recurse-submodules -j8 git://github.com/branning/cantrips.git

## checkout submodules in already cloned repos

    git submodule update --init --recursive

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
