__get_apps() {
  local apps=$(cf apps)
  [[ $apps =~ "OK" ]] && COMPREPLY+=( $(compgen -W "$(echo "$apps" | awk '!/^(Getting.*)?(OK)?(name.*)?$/ {print $1}')" -- ${cur}) )
}

_cf() {
    local cur prev global_opts cmds before_prev
    COMPREPLY=()
    _get_comp_words_by_ref -n : cur prev
    # cf [global options] command [arguments...] [command options]
    global_opts="--help -h -v"
    cmds="help version login logout passwd target api auth apps app push scale delete rename start stop restart restage restart-app-instance run-task tasks terminate-task events files logs env set-env unset-env stacks stack copy-source create-app-manifest get-health-check set-health-check enable-ssh disable-ssh ssh-enabled ssh marketplace services service create-service update-service delete-service rename-service create-service-key service-keys service-key delete-service-key bind-service unbind-service bind-route-service unbind-route-service create-user-provided-service update-user-provided-service orgs org create-org delete-org rename-org spaces space create-space delete-space rename-space allow-space-ssh disallow-space-ssh space-ssh-allowed domains create-domain delete-domain create-shared-domain delete-shared-domain router-groups routes create-route check-route map-route unmap-route delete-route delete-orphaned-routes network-policies add-network-policy remove-network-policy buildpacks create-buildpack update-buildpack rename-buildpack delete-buildpack create-user delete-user org-users set-org-role unset-org-role space-users set-space-role unset-space-role quotas quota set-quota create-quota delete-quota update-quota share-private-domain unshare-private-domain space-quotas space-quota create-space-quota update-space-quota delete-space-quota set-space-quota unset-space-quota service-auth-tokens create-service-auth-token update-service-auth-token delete-service-auth-token service-brokers create-service-broker update-service-broker delete-service-broker rename-service-broker rename-service-broker migrate-service-instances purge-service-offering purge-service-instance service-access enable-service-access disable-service-access security-group security-groups create-security-group update-security-group delete-security-group bind-security-group unbind-security-group bind-staging-security-group staging-security-groups unbind-staging-security-group bind-running-security-group running-security-groups unbind-running-security-group running-environment-variable-group staging-environment-variable-group set-staging-environment-variable-group set-running-environment-variable-group isolation-segments create-isolation-segment delete-isolation-segment enable-org-isolation disable-org-isolation set-org-default-isolation-segment reset-org-default-isolation-segment set-space-isolation-segment reset-space-isolation-segment feature-flags feature-flag enable-feature-flag disable-feature-flag curl config oauth-token ssh-code add-plugin-repo remove-plugin-repo list-plugin-repos repo-plugins plugins install-plugin uninstall-plugin"

    if (( ${#COMP_WORDS[@]} > 2 )); then
      before_prev="${COMP_WORDS[COMP_CWORDS-2]}"
      # case "${before_prev}" in
        # a
      # esac
    fi
    case "${prev}" in
      app)
        COMPREPLY=( $(compgen -W "push scale delete rename start stop retart restage" -- ${cur}) )
        return 0
        ;;
      push|scale|delete|rename|start|stop|retart|restage)
        __get_apps
        return 0
        ;;
    esac
    case "${cur}" in
        -*)
            COMPREPLY=( $(compgen -W "${global_opts}" -- ${cur}) )
            return 0
            ;;
        *)
            COMPREPLY=( $(compgen -W "${global_opts} ${cmds}" -- ${cur}) )
            return 0
            ;;
    esac
}

complete -F _cf cf
