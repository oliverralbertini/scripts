_target_complete_entries()
{
    targets=( $(uaac targets 2>/dev/null) )
    for i in ${targets[@]}; do
        target="${i#*https}"
        COMPREPLY+="https${target}"
    done
}

_uaac()
{
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts="--help --vesion --verbose --debug --config --zone -h -v -d -t -z"
    cmds="curl client clients secret groups group member users user password token target targets context contexts help version password stats signing prompts me info"

    case "${prev}" in
        uaac)
            ;;
        help)
            COMPREPLY=( $(compgen -W "${cmds}" -- ${cur}) )
            return 0
            ;;
        curl)
            curl_opts="-X -d -H -k --request --data --header --insecure"
            COMPREPLY=( $(compgen -W "${curl_opts}" -- ${cur}) )
            return 0
            ;;
        -X|--request)
            requests="PUT GET POST PATCH DELETE"
            COMPREPLY=( $(compgen -W "${requests}" -- ${cur}) )
            return 0
            ;;
        clients|groups)
            clients_opts="-a --attributes --start --count"
            COMPREPLY=( $(compgen -W "${clients_opts}" -- ${cur}) )
            return 0
            ;;
        client)
            client_cmds="get add update delete"
            COMPREPLY=( $(compgen -W "${client_cmds}" -- ${cur}) )
            return 0
            ;;
        secret)
            secret_cmds="set change"
            COMPREPLY=( $(compgen -W "${secret_opts}" -- ${cur}) )
            return 0
            ;;
        group)
            group_cmds="get add update delete mappings map unmap"
            COMPREPLY=( $(compgen -W "${group_cmds}" -- ${cur}) )
            return 0
            ;;
        member)
            member_cmds="add delete"
            COMPREPLY=( $(compgen -W "${member_cmds}" -- ${cur}) )
            return 0
            ;;
        user)
            user_cmds="get add delete update ids unlock deactivate activate"
            COMPREPLY=( $(compgen -W "${user_cmds}" -- ${cur}) )
            return 0
            ;;
        password)
            password_cmds="get add delete update ids unlock deactivate activate"
            COMPREPLY=( $(compgen -W "${password_cmds}" -- ${cur}) )
            return 0
            ;;
        token)
            token_cmds="get client owner sso refresh authcode implicit decode delete"
            COMPREPLY=( $(compgen -W "${token_cmds}" -- ${cur}) )
            return 0
            ;;
        target)
            target_opts="-f --force --no-force --ca-cert --skip-ssl-validation"
            COMPREPLY=( $(compgen -W "${target_opts}" -- ${cur}) )
            _target_complete_entries
            return 0
            ;;
        targets|info|me|prompts|--version|-v|version|contexts)
            return 0
            ;;
        *)
            ;;
    esac
    case "${cur}" in
        -*)
            COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
            return 0
            ;;
        *)
            COMPREPLY=( $(compgen -W "${opts} ${cmds}" -- ${cur}) )
            return 0
            ;;
    esac
}
complete -F _uaac uaac
