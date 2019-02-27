#!/usr/bin/env bash

yubigit() {
  local GPG_TTY SSH_AUTH_SOCK ssh_config ssh_config_url
  gpgconf --kill gpg-agent
  gpg-connect-agent --quiet updatestartuptty /bye > /dev/null
  ! [[ -d $HOME/.ssh/controlmasters ]] && mkdir "${HOME}/.ssh/controlmasters"
  ssh_config=${HOME}/.ssh/config
  ssh_config_url=https://raw.githubusercontent.com/oliverralbertini/scripts/master/ssh_config
  grep --color=auto "Host github.com" "$ssh_config" > /dev/null || \
    curl "$ssh_config_url" >> "$ssh_config"
  GPG_TTY=$(tty)
  SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
  export GPG_TTY SSH_AUTH_SOCK
  ssh -T github.com
}

yubigit
