_uaac()
{
    local cur prev before_prev opts cmds
    COMPREPLY=()
    # cur="${COMP_WORDS[COMP_CWORD]}"
    # prev="${COMP_WORDS[COMP_CWORD-1]}"
    _get_comp_words_by_ref -n : cur prev
    (( ${#COMP_WORDS[@]} > 2 )) && before_prev="${COMP_WORDS[COMP_CWORD-2]}"
    opts="--help --vesion --verbose --debug --config --zone -h -v -d -t -z"
    cmds="curl client clients secret groups group member users user password token target targets context contexts help version password stats signing prompts me info"

    case "${before_prev}" in
      uaac)
        ;;
      client)
        clients="$(uaac clients | awk '!/:/ {print $0}')"
        case "${prev}" in
          get)
            COMPREPLY+=( $(compgen -W "${clients} -a --attributes" -- ${cur}) )
            return 0
            ;;
        esac
        ;;
      user)
        users="$(uaac users | grep username: | awk '{print $2}')"
        case "${prev}" in
          get)
            COMPREPLY+=( $(compgen -W "${users} -a --attributes" -- ${cur}) )
            return 0
            ;;
        esac
        ;;
      group)
        groups="$(uaac groups | grep -v -e : -e meta -e \- -e roles)"
        case "${prev}" in
          get)
            COMPREPLY+=( $(compgen -W "${groups} -a --attributes" -- ${cur}) )
            return 0
            ;;
        esac
        ;;
      *)
        ;;
    esac
    case "${prev}" in
        uaac)
            ;;
        --debug|-d)
            opts="--verbose --config --zone -t -z"
            ;;
        --help|-h|help)
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
        users|clients|groups)
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
        group)
            groups="$(uaac groups | awk '{print $NF}')"
            COMPREPLY=( $(compgen -W "${groups}" -- ${cur}) )
            return 0
            ;;
        context)
            contexts="$(uaac contexts | awk '{print $NF}')"
            COMPREPLY=( $(compgen -W "${contexts}" -- ${cur}) )
            return 0
            ;;
        target)
            target_opts="-f --force --no-force --ca-cert --skip-ssl-validation"
            COMPREPLY=( $(compgen -W "${target_opts}" -- ${cur}) )
            targets="$(uaac targets | awk '{print $NF}')"
            # if there were no targets, then return
            [[ $targets =~ "targets" ]] && return 0
            COMPREPLY+=( $(compgen -W "${targets}" -- ${cur}) )
            __ltrim_colon_completions "$cur"
            return 0
            ;;
        targets|info|me|prompts|--version|-v|version|contexts)
            return 0
            ;;
        password)
            COMPREPLY=( "strength" )
            ;;
        strength)
            return 0
            ;;
        signing)
            COMPREPLY=( "key" )
            return 0
            ;;
        key|stats)
            COMPREPLY=( $(compgen -W "-c --client -s --secret" -- ${cur} )
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
