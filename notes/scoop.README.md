## Update all Scoop apps

From a Git Bash shell:

    scoop list | awk 'NR>4 { print $1 }' | xargs scoop update
