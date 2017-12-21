yubigit()
(
    gpg-connect-agent --quiet updatestartuptty /bye >/dev/null;
    if [[ ! -d $HOME/.ssh/controlmasters ]]; then
      mkdir "${HOME}/.ssh/controlmasters";
    fi;
    ssh_config="${HOME}/.ssh/config";
    ssh_config_url="https://raw.githubusercontent.com/oliverralbertini/scripts/master/ssh_config";
    grep "Host github.com" "$ssh_config" >/dev/null || curl $ssh_config_url >> $ssh_config;
    export GPG_TTY=$(tty);
    export SSH_AUTH_SOCK="$HOME/.gnupg/S.gpg-agent.ssh";
    if which kr >/dev/null 2>&1; then
        kr unpair >/dev/null;
    fi;
    ssh github.com
)
