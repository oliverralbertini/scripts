#!/usr/bin/env bash
yubishell() {
  local GPG_TTY SSH_AUTH_SOCK PS1
  gpgconf --kill gpg-agent
  gpg-connect-agent --quiet updatestartuptty /bye
  [[ ! -d ${HOME}/.ssh/controlmasters ]] && mkdir "${HOME}/.ssh/controlmasters"
  GPG_TTY=$(tty)
  SSH_AUTH_SOCK=${HOME}/.gnupg/S.gpg-agent.ssh
  PS1="\\[\\e[31m\\][YUBI]\\[\\e[0m\\] \$ "
  export GPG_TTY SSH_AUTH_SOCK PS1
  command kr > /dev/null 2>&1 && kr unpair
  if [[ -z "$*" ]]; then
    bash --norc
  else
    bash --norc -c "$*"
  fi
}

yubishell "$*"
