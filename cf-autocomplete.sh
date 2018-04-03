# http://cli.cloudfoundry.org/en-US/cf/
__get_spaces() {
  local spaces=$(CF_COLOR=false cf spaces 2>/dev/null)
  [[ $spaces =~ "FAILED" ]] && return
  COMPREPLY+=( $(compgen -W "$(echo "$spaces" | awk '!/^(Getting.*)?(OK)?(name.*)?$/ {print $1}')" -- ${cur}) )
}

__get_spaces_in_org() {
  org="$1"
  local spaces=$(CF_COLOR=false cf org $org 2>/dev/null)
  [[ $spaces =~ "FAILED" ]] && return
  COMPREPLY+=( $(compgen -W "$(echo "$spaces" | grep spaces | cut -d':' -f2 | sed -e 's/,//g')" -- ${cur}) )
}

__get_orgs() {
  local orgs=$(CF_COLOR=false cf orgs 2>/dev/null)
  [[ $orgs =~ "FAILED" ]] && return
  COMPREPLY+=( $(compgen -W "$(echo "$orgs" | awk '!/^(Getting.*)?(OK)?(name.*)?$/ {print $1}')" -- ${cur}) )
}

__get_apps() {
  local apps=$(CF_COLOR=false cf apps)
    if [[ $apps =~ "OK" ]] && ! [[ $apps =~ "No apps found" ]]; then
      COMPREPLY+=( $(compgen -W "$(echo "$apps" | awk '!/^(Getting.*)?(OK)?(name.*)?$/ {print $1}')" -- ${cur}) )
    fi
}

__get_tasks() {
  local tasks=$(CF_COLOR=false cf tasks)
    # if [[ $tasks =~ "OK" ]] && ! [[ $tasks =~ "No apps found" ]]; then
      # COMPREPLY+=( $(compgen -W "$(echo "$tasks" | awk '!/^(Getting.*)?(OK)?(name.*)?$/ {print $1}')" -- ${cur}) )
    # fi
}

__get_files() {
  local files
}

__get_offerings() {
  local offerings
}

__get_envs() {
  local envs
}

__get_stacks() {
  local stacks
}

__get_services() {
  local services
}

__get_domains() {
  local domains=$(CF_COLOR=false cf domains 2>/dev/null)
  COMPREPLY+=( $(compgen -W "$(echo "$domains" | awk '!/^(Getting.*)?(OK)?(name.*)?$/ {print $1}')" -- ${cur}) )
}

__get_router_groups() {
  local router_groups
}

__get_routes() {
  local routes
}

__get_network_policies() {
  local network_policies
}

__get_buildpacks() {
  local buildpacks
}

__get_org_users() {
  local org_users
}

__get_space_users() {
  local space_users
}

__get_quotas() {
  local quotas=$(CF_COLOR=false cf quotas 2>/dev/null)
  COMPREPLY+=( $(compgen -W "$(echo "$quotas" | awk '!/^(Getting.*)?(OK)?(name.*)?$/ {print $1}')" -- ${cur}) )
}

__get_space_quotas() {
  local space_quotas
}

__get_service_auth_tokens() {
  local service_auth_tokens
}

__get_service_brokers() {
  local service_brokers
}

__get_space_quotas() {
  local space_quotas
}

__get_security_groups() {
  local security_groups
}

__get_staging_security_groups() {
  local staging_security_groups
}

__get_running_security_groups() {
  local running_security_groups
}

__get_isolation_segments() {
  local isolation_segments
}

__get_feature_flags() {
  local feature_flags=$(CF_COLOR=false cf feature-flags 2>/dev/null)
  COMPREPLY+=( $(compgen -W "$(echo "$feature_flags" | awk '!/^(Retrieving.*)?(OK)?(features.*)?$/ {print $1}')" -- ${cur}) )
}

__get_enabled_feature_flags() {
  local feature_flags=$(CF_COLOR=false cf feature-flags 2>/dev/null | grep "enabled")
  COMPREPLY+=( $(compgen -W "$(echo "$feature_flags" | awk '!/^(Retrieving.*)?(OK)?(features.*)?$/ {print $1}')" -- ${cur}) )
}

__get_disabled_feature_flags() {
  local feature_flags=$(CF_COLOR=false cf feature-flags 2>/dev/null | grep "disabled")
  COMPREPLY+=( $(compgen -W "$(echo "$feature_flags" | awk '!/^(Retrieving.*)?(OK)?(features.*)?$/ {print $1}')" -- ${cur}) )
}

__get_plugin_repos() {
  local plugin_repos
}

__get_plugins() {
  local plugins
}

__get_v3_apps() {
  local v3_apps
}

__get_v3_droplets() {
  local v3_droplets
}

__get_v3_packages() {
  local v3_packages
}

_cf() {
  local cur prev global_opts cmds before_prev
  COMPREPLY=()
  _get_comp_words_by_ref -n : cur prev
  # cf [global options] command [arguments...] [command options]
  global_opts="--help -h -v"
  local target_opts="-o -s"
  cmds="help version login logout passwd target api auth apps app push scale delete rename start stop restart restage restart-app-instance run-task tasks terminate-task events files logs env set-env unset-env stacks stack copy-source create-app-manifest get-health-check set-health-check enable-ssh disable-ssh ssh-enabled ssh marketplace services service create-service update-service delete-service rename-service create-service-key service-keys service-key delete-service-key bind-service unbind-service bind-route-service unbind-route-service create-user-provided-service update-user-provided-service orgs org create-org delete-org rename-org spaces space create-space delete-space rename-space allow-space-ssh disallow-space-ssh space-ssh-allowed domains create-domain delete-domain create-shared-domain delete-shared-domain router-groups routes create-route check-route map-route unmap-route delete-route delete-orphaned-routes network-policies add-network-policy remove-network-policy buildpacks create-buildpack update-buildpack rename-buildpack delete-buildpack create-user delete-user org-users set-org-role unset-org-role space-users set-space-role unset-space-role quotas quota set-quota create-quota delete-quota update-quota share-private-domain unshare-private-domain space-quotas space-quota create-space-quota update-space-quota delete-space-quota set-space-quota unset-space-quota service-auth-tokens create-service-auth-token update-service-auth-token delete-service-auth-token service-brokers create-service-broker update-service-broker delete-service-broker rename-service-broker rename-service-broker migrate-service-instances purge-service-offering purge-service-instance service-access enable-service-access disable-service-access security-group security-groups create-security-group update-security-group delete-security-group bind-security-group unbind-security-group bind-staging-security-group staging-security-groups unbind-staging-security-group bind-running-security-group running-security-groups unbind-running-security-group running-environment-variable-group staging-environment-variable-group set-staging-environment-variable-group set-running-environment-variable-group isolation-segments create-isolation-segment delete-isolation-segment enable-org-isolation disable-org-isolation set-org-default-isolation-segment reset-org-default-isolation-segment set-space-isolation-segment reset-space-isolation-segment feature-flags feature-flag enable-feature-flag disable-feature-flag curl config oauth-token ssh-code add-plugin-repo remove-plugin-repo list-plugin-repos repo-plugins plugins install-plugin uninstall-plugin v3-apps v3-app v3-create-app v3-push v3-scale v3-delete v3-start v3-stop v3-restart v3-restage v3-stage v3-restart-app-instance v3-droplets v3-set-droplet v3-set-env v3-unset-env v3-get-health-check v3-set-health-check v3-packages v3-create-package"

  if (( ${#COMP_WORDS[@]} > 2 )); then
    before_prev="${COMP_WORDS[COMP_CWORD-2]}"
    case "${before_prev}" in
      space-users)
        __get_spaces_in_org "$prev"
        return 0
        ;;
      target)
        case "${prev}" in
          -o)
            __get_orgs
            return 0
            ;;
          -s)
            __get_spaces
            return 0
            ;;
        esac
        ;;
    esac
  fi
  case "${prev}" in
    login)
      COMPREPLY=( $(compgen -W "-u -p --skip-ssl-validation --sso -a" -- ${cur}) )
      return 0
      ;;
    api)
      COMPREPLY=( $(compgen -W "--unset --skip-ssl-validation" -- ${cur}) )
      return 0
      ;;
    disable-feature-flag)
      __get_enabled_feature_flags
      return 0
      ;;
    enable-feature-flag)
      __get_disabled_feature_flags
      return 0
      ;;
    feature-flag)
      __get_feature_flags
      return 0
      ;;
    target)
      COMPREPLY=( $(compgen -W "${target_opts}" -- ${cur}) )
      return 0
      ;;
    org-users|space-users)
      __get_orgs
      return 0
      ;;
    set-env|restage|files|app|push|scale|delete|rename|start|stop|retart|restage)
      __get_apps
      return 0
      ;;
    -p)
      case "${COMP_WORDS[1]}" in
        push|create-app-manifest|create-user-provided-service|update-user-provided-service|update-buildpack|v3-create-package|v3-push)
          # just default (files)
          COMPREPLY=()
          ;;
      esac
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

complete -o default -F _cf cf
