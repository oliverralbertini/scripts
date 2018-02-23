__get_users() {
    local users="$(uaac users | grep username: | awk '{print $2}')"
    COMPREPLY+=( $(compgen -W "${users}" -- ${cur}) )
}

__get_groups() {
    local groups="$(uaac groups | grep -v -e : -e meta -e \- -e roles)"
    COMPREPLY+=( $(compgen -W "${groups}" -- ${cur}) )
}

__get_clients() {
    local clients="$(uaac clients | awk '!/:/ {print $0}')"
    [[ $clients =~ "{" ]] && return
    COMPREPLY+=( $(compgen -W "${clients}" -- ${cur}) )
}

__get_contexts() {
    local contexts="$(uaac contexts | awk '{print $NF}')"
    COMPREPLY=( $(compgen -W "${contexts}" -- ${cur}) )
}

__get_targets() {
    local targets="$(uaac targets | awk '{print $NF}')"
    # if there were no targets, then return
    [[ $targets =~ "targets" ]] && return 0
    COMPREPLY+=( $(compgen -W "${targets}" -- ${cur}) )
    __ltrim_colon_completions "$cur"
}

_uaac()
{
    local cur prev before_prev opts cmds
    COMPREPLY=()
    # cur="${COMP_WORDS[COMP_CWORD]}"
    # prev="${COMP_WORDS[COMP_CWORD-1]}"
    _get_comp_words_by_ref -n : cur prev
    opts="--help --vesion --verbose --debug --config --zone -h -v -d -t -z"
    cmds="curl client clients secret groups group member users user password token target targets context contexts help version password stats signing prompts me info"

    if (( ${#COMP_WORDS[@]} > 2 )); then
        before_prev="${COMP_WORDS[COMP_CWORD-2]}"
        case "${before_prev}" in
            secret)
                if [[ $prev == "set" ]]; then
                    __get_clients
                    COMPREPLY+=( $(compgen -W "-s --secret" -- ${cur}) )
                    return 0
                elif [[ $prev == "change" ]]; then
                    COMPREPLY+=( $(compgen -W "-s --secret --old_secret" -- ${cur}) )
                    return 0
                fi
                ;;
            client)
                __get_clients
                case "${prev}" in
                    add)
                        COMPREPLY+=( $( compgen -W "--name --scope --authorized_grant_types --authorities --access_token_validity --refresh_token_validity --redirect_uri --autoapprove --signup_redirect_url --clone -s --secret -i --interactive --no-interactive" -- ${cur}) )
                        return 0
                        ;;
                    update)
                        COMPREPLY+=( $( compgen -W "--name --scope --authorized_grant_types --authorities --access_token_validity --refresh_token_validity --redirect_uri --autoapprove --signup_redirect_url --del-attrs -i --interactive --no-interactive" -- ${cur}) )
                        return 0
                        ;;
                    get)
                        COMPREPLY+=( $(compgen -W "-a --attributes" -- ${cur}) )
                        return 0
                        ;;
                    delete)
                        return 0
                        ;;
                esac
                ;;
            password)
                if [[ $prev == "set" ]]; then
                    __get_users
                    COMPREPLY+=( $(compgen -W "-p --password" -- ${cur}) )
                    return 0
                elif [[ $prev == "change" ]]; then
                    COMPREPLY+=( $(compgen -W "-p --password --old_password -o" -- ${cur}) )
                    return 0
                fi
                ;;
            user)
                __get_users
                case "${prev}" in
                    get)
                        COMPREPLY+=( $(compgen -W "--origin -a --attributes" -- ${cur}) )
                        return 0
                        ;;
                    add)
                        COMPREPLY+=( $(compgen -W "--given_name --family_name --emails --phones --origin -p --password" -- ${cur}) )
                        return 0
                        ;;
                    update)
                        COMPREPLY+=( $(compgen -W "--given_name --family_name --emails --phones --origin --del_attrs" -- ${cur}) )
                        return 0
                        ;;
                    delete)
                        COMPREPLY+=( $(compgen -W "--origin" -- ${cur}) )
                        return 0
                        ;;
                    ids|unlock|deactivate|activate)
                        return 0
                        ;;
                esac
                ;;
            add|delete)
                if (( ${#COMP_WORDS[@]} > 3 )) && [[ ${COMP_WORDS[COMP_CWORDS-3]} == "member" ]]; then
                    __get_users
                fi
                ;;
            member)
                __get_groups
                case "${prev}" in
                    add|delete)
                        COMPREPLY+=( $(compgen -W "-a --attributes" -- ${cur}) )
                        return 0
                        ;;
                esac
                ;;
            group)
                __get_groups
                case "${prev}" in
                    get)
                        COMPREPLY+=( $(compgen -W "-a --attributes" -- ${cur}) )
                        return 0
                        ;;
                    add|delete)
                        return 0
                        ;;
                    map)
                        COMPREPLY+=( $(compgen -W "--id --name --origin" -- ${cur}) )
                        return 0
                        ;;
                    unmap)
                        COMPREPLY+=( $(compgen -W "--origin" -- ${cur}) )
                        return 0
                        ;;
                esac
                ;;
            *)
                ;;
        esac
    fi
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
        mappings)
            COMPREPLY=( $(compgen -W "--start --count" -- ${cur}) )
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
            __get_groups
            return 0
            ;;
        context)
            __get_contexts
            return 0
            ;;
        target)
            target_opts="-f --force --no-force --ca-cert --skip-ssl-validation"
            COMPREPLY=( $(compgen -W "${target_opts}" -- ${cur}) )
            __get_targets
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
