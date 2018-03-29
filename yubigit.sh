yubigit()
(
    gpg-connect-agent --quiet updatestartuptty /bye >/dev/null;
    [[ ! -d $HOME/.ssh/controlmasters ]] && mkdir "${HOME}/.ssh/controlmasters";
    ssh_config="${HOME}/.ssh/config";
    ssh_config_url="https://raw.githubusercontent.com/oliverralbertini/scripts/master/ssh_config";
    grep "Host github.com" "$ssh_config" >/dev/null || curl "$ssh_config_url" >> "$ssh_config";
    local pau_time current_time tunnel_duration;
    if [[ $(uname) == [Ll]inux ]]; then
        pau_time="$(date --date='6:00 pm today' +%s)";
    else
        pau_time="$(date -j -f "%a %b %d %H:%M:%S %Z %Y" "$(date "+%a %b %d 18:00:00 %Z %Y")" "+%s")";
    fi;
    current_time="$(date "+%s")";
    tunnel_duration=$(( pau_time - current_time ));
    (( tunnel_duration < 0 )) && tunnel_duration=3600;
    sed -ie "/Host github.com$/,/Host .*$/ s/^     ControlPersist.*$/     ControlPersist $tunnel_duration/" ~/.ssh/config
    export GPG_TTY=$(tty);
    export SSH_AUTH_SOCK="${HOME}/.gnupg/S.gpg-agent.ssh";
    command kr >/dev/null 2>&1 && kr unpair >/dev/null;
    ssh github.com
)
