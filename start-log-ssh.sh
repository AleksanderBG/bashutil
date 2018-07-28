#!/usr/bin/env bash

print-help() {
cat <<EOF
Usage: source start-log-ssh.sh [ssh args...]
This script MUST be sourced, but it should fail safely if it isn't (uses jobs).
This script will create multiple SSHs to the host you specify in SSH args.
Each SSH instance forwards one log to the current directory.
There is also an error.* file, one per SSH instance, containing the errstream.
All error streams are also written to stdout.

SSH instances are started as background jobs, so you likely want to reserve
this shell only to keep them alive. You can use screen / tmux if you want.
EOF
}

[[ $# = 0 ]] && print-help && return

ERR=

ensure-not-present() {
	if [[ -e $1 ]]; then
		echo "$1 is present! Please remove it before running script!"
		ERR=err
	fi
}

LOGS=()

for log in "${LOGS[@]}" ; do
	name=${log##[^/]*/}
	ensure-not-present "$name"
	ensure-not-present error."$name"
done

[[ $ERR = err ]] && return

ssh -f -N -M -S ssh.sock -o ServerAliveInterval=20 "$@"

for log in "${LOGS[@]}" ; do
	name=${log##[^/]*/}
	</dev/null ssh -S ssh.sock "$@" -o ServerAliveInterval=20 'tail -F $(iwgethome)/'"$log" \
		2> >(tee "__error.$name") > "$name" &
done
