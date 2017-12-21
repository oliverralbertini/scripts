yubishell ()
{
    ( gpg-connect-agent --quiet updatestartuptty /bye;
    if [[ ! -d $HOME/.ssh/controlmasters ]]; then
      mkdir "${HOME}/.ssh/controlmasters"
    fi
    ssh_config="${HOME}/.ssh/config"
    ssh_config_url="https://raw.githubusercontent.com/oliverralbertini/scripts/master/ssh_config"
    grep "Host github.com" "$ssh_config" >/dev/null || curl $ssh_config_url >> $ssh_config
    export GPG_TTY=$(tty);
    export SSH_AUTH_SOCK="$HOME/.gnupg/S.gpg-agent.ssh";
    export PS1="\[\e[31m\][YUBI]\[\e[0m\] \$ ";
    if which kr > /dev/null 2>&1; then
        kr unpair;
    fi;
    bash --norc )
}
