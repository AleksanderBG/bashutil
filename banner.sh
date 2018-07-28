
banner() {
	local middle
	local barrier
	middle="---   $1   ---"
	barrier=${middle//?/=}
	echo
	echo "$barrier"
	echo "$middle"
	echo "$barrier"
	if [[ -n $2 ]]
	then
		echo "$2"
	fi
	echo
}
