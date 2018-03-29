yubishell ()
(
    gpg-connect-agent --quiet updatestartuptty /bye;
    [[ ! -d ${HOME}/.ssh/controlmasters ]] && mkdir "${HOME}/.ssh/controlmasters";
    export GPG_TTY=$(tty);
    export SSH_AUTH_SOCK="${HOME}/.gnupg/S.gpg-agent.ssh";
    export PS1="\[\e[31m\][YUBI]\[\e[0m\] \$ ";
    command kr > /dev/null 2>&1 && kr unpair;
    bash --norc
)
