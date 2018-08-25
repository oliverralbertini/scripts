#!/usr/bin/env bash
HOST=${1:?Must be fully qualified domain name.}

PREFIX=$(pass p-vpn/pin)
CODE=$(oathtool --base32 --totp "$(pass p-vpn/key)")
printf '%s' "${PREFIX}${CODE}" | pbcopy

osascript <<END_OSASCRIPT >/dev/null
tell application "Tunnelblick"
  connect "Pivotal West Coast (Palo Alto)"
end tell
END_OSASCRIPT

until ping -c 1 "$HOST" >/dev/null 2>&1; do
  sleep 1
done

ssh -t "${HOST%%.*}" /usr/local/bin/tmuxp load main

osascript <<END_OSASCRIPT >/dev/null
  tell application "Tunnelblick"
    disconnect "Pivotal West Coast (Palo Alto)"
  end tell
END_OSASCRIPT
