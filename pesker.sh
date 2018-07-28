#!/usr/bin/env bash
pesker-for-positive-response() {
	local EXIT_CODE=${2:-0}
	printf '%s ' "$1 "
	while read -r response
	do
		if [[ $response =~ yes|y ]] ; then break
		elif [[ $response =~ no|n ]] ; then exit "$EXIT_CODE"
		else printf "Please type yes/no: "
		fi
	done
}
