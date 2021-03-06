lpass ()
{
    ! [[ $1 == login ]] && {
        command lpass "$@";
        return
    };
    local end_time current_time LPASS_AGENT_TIMEOUT;
    if [[ $(uname) == [Ll]inux ]]; then
        end_time="$(date --date='6:00 pm today' +%s)";
    else
        end_time="$(date -j -f "%a %b %d %H:%M:%S %Z %Y" "$(date "+%a %b %d 18:00:00 %Z %Y")" "+%s")";
    fi;
    current_time="$(date "+%s")";
    LPASS_AGENT_TIMEOUT=$(( end_time - current_time ));
    (( LPASS_AGENT_TIMEOUT < 0 )) && LPASS_AGENT_TIMEOUT=3600;
    export LPASS_AGENT_TIMEOUT;
    echo "Using LPASS_AGENT_TIMEOUT = ${LPASS_AGENT_TIMEOUT} seconds.";
    command lpass "$@"
}
