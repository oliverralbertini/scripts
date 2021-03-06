#!/usr/bin/env bash
HOST=${1:?Must be fully qualified domain name.}

PREFIX=$(pass p-vpn/pin)
CODE=$(oathtool --base32 --totp "$(pass p-vpn/key)")

echo 'Placing one-time password in your paste buffer.'
printf '%s' "${PREFIX}${CODE}" | pbcopy

echo 'Starting tunnelblick.'
osascript <<END_OSASCRIPT >/dev/null
tell application "Tunnelblick"
  connect "Pivotal West Coast (Palo Alto)"
end tell
END_OSASCRIPT

echo "Waiting for connection to ${HOST}."
until ping -c 1 "$HOST" >/dev/null 2>&1; do
  sleep 1
done

~/bin/yubishell.sh TERM=xterm-256color ssh -t "${HOST%%.*}" /usr/local/bin/tmuxp load main

echo 'Stopping tunnelblick.'
osascript <<END_OSASCRIPT >/dev/null
  tell application "Tunnelblick"
    disconnect "Pivotal West Coast (Palo Alto)"
  end tell
END_OSASCRIPT
