yubishell ()
(
    gpg-connect-agent --quiet updatestartuptty /bye;
    [[ ! -d ${HOME}/.ssh/controlmasters ]] && mkdir "${HOME}/.ssh/controlmasters";
    ssh_config="${HOME}/.ssh/config";
    ssh_config_url="https://raw.githubusercontent.com/oliverralbertini/scripts/master/ssh_config"
    grep "Host github.com" "$ssh_config" >/dev/null || curl "$ssh_config_url" >> "$ssh_config"
    export GPG_TTY=$(tty);
    export SSH_AUTH_SOCK="${HOME}/.gnupg/S.gpg-agent.ssh";
    export PS1="\[\e[31m\][YUBI]\[\e[0m\] \$ ";
    which kr > /dev/null 2>&1 && kr unpair;
    bash --norc
)
