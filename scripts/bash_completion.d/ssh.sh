#!/usr/bin/env bash
#
# Install ssh hostname Bash completion
# from https://unix.stackexchange.com/a/181603/148498

here=$(cd $(dirname $BASH_SOURCE[0]); echo $PWD)

ssh_comment='install ssh hostname completion'
if ! grep -q "$ssh_comment" ~/.profile
then
  echo 'Installing ssh hostname Bash completion'

  # first write the file containing the _ssh completion function
  cat <<'SSH_SCRIPT' > $here/../ssh-completion.bash
_ssh()  {
     local cur prev opts;
     COMPREPLY=();
     cur="${COMP_WORDS[COMP_CWORD]}";
     prev="${COMP_WORDS[COMP_CWORD-1]}";
     opts=$(grep '^Host' ~/.ssh/config | grep -v '[?*]' | cut -d ' ' -f 2-);
     COMPREPLY=( $(compgen -W "$opts" -- ${cur}) );
     return 0;
}
complete -F _ssh ssh
SSH_SCRIPT

  # second write the bits to load that file from the profile
  cat <<SSH >> ~/.profile

# ${ssh_comment}
if [ -n "\$BASH_VERSION" ]
then
  source $here/../ssh-completion.bash
fi
SSH
fi

