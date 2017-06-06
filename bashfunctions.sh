
urlencode() {
	local LC_COLLATE=C
	local length="${#1}"
	local c=""
	local i
	for (( i = 0; i < length; i++ )); do
		c="${1:i:1}"
		case "$c" in
			[A-Za-z0-9.~_-]) printf '%s' "$c" ;;
			*) printf '%%%02X' "$c" ;;
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

function array_insert {
	# options: arrayname index [value]
	if ! declare -p "$1" 2>/dev/null | grep -q '^declare -a'; then
		printf '%s: not an array: %s\n' "$0" "$1" >&2
		return 1
	fi
	local -n source="$1"
	local -a indices=( "${!source[@]}" )
	for ((i=${#indices[@]}-1; i>=$2; i--)) ; do
		source[$((i+1))]="${source[$i]}"
	done
	if [ -n "$3" ]; then
		source[$2]="$3"
	fi
}

function crunch_pwd {
	local lpwd="$PWD"
	[[ $PWD = ${HOME}* ]] && lpwd="~${lpwd#$HOME}"
	while [[ $lpwd =~ (.*)(/[._]?[a-z])[a-z]+(/.*) ]]; do
		lpwd="${BASH_REMATCH[1]}${BASH_REMATCH[2]}${BASH_REMATCH[3]}"
	done
	printf '%s' "$lpwd"
}

# Add lz4 support to tar in FreeBSD < 11
function tar {
	if [[ "$1" == *f ]] && [ -s "$2" -a "$(uname -s)" = FreeBSD -a "$(uname -r)" < 11 ]; then
		case "$2" in
			*.lz4)
				local opt="$1"
				local what="$2"
				shift 2
				lz4cat "$what" | command tar "$opt" - "$@"
				return $?
				;;
		esac
	fi
	command tar "$@"
}

