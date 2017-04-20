
urlencode() {
	local LC_COLLATE=C
	local length="${#1}"
	for (( i = 0; i < length; i++ )); do
		local c="${1:i:1}"
		case "$c" in
			[A-Za-z0-9.~_-]) printf "$c" ;;
			*) printf '%%%02X' "'$c" ;;
		esac
	done
}
urldecode() {
	local url_encoded="${1//+/ }"
	printf '%b' "${url_encoded//%/\\x}"
}


function array_contains {
	# options: arrayname value
	if [[ ${BASH_VERSION%%.*} -ge 4 ]]; then
		# Avoid the loop
		local -A _arr=()
		eval _arr=( $(eval printf '[%s]="1"\ ' "\${$1[@]}") )
		return $(( 1 - 0${_arr[$2]} ))
	else
		eval 'local values=("${'$1'[@]}")'
		local element
		for element in "${values[@]}"; do
			[[ "$element" == "$2" ]] && return 0
		done
		return 1
	fi
}

