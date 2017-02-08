
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


function array_contains_old {
	# options: arrayname value
	eval 'local values=("${'$1'[@]}")'
	local element
	for element in "${values[@]}"; do
		[[ "$element" == "$2" ]] && return 0
	done
	return 1
}

# Avoid the loop
function array_contains {
	# options: arrayname value
	local -A _arr=()
	eval _arr=( $(eval printf '[%s]="1"\ ' "\${$1[@]}") )
	return $(( 1 - 0${_arr[$2]} ))
}

# Avoid external binaries
# TODO: can we support `-m` option, the multibyte version of `-c`?
function wc.sh {
	local opt lwc=""
	local c=0 w=0 l=0 tc=0 tw=0 tl=0
	local -a inp=() junk
	# options: (-[lwc]) (input)
	while getopts lwc opt; do
		case "$opt" in
			l|w|c)	lwc="$lwc$opt" ;;
			*)	printf 'wc: illegal option -- %s\nusage: wc [-lwc] [file ...]\n' "$opt"; exit 1 ;;
		esac
	done
	lwc=${lwc:-lwc}
	shift $((OPTIND - 1))
	if [ $# -eq 0 ]; then
		files=( "-" )
	else
		files=( "$@" )
	fi

	for file in "${files[@]}"; do
		l=0; w=0; c=0
		if [ "$file" = - ]; then
			file="<(cat)"
		elif [ ! -f "$file" ]; then
			printf 'wc: %s: open: No such file or directory\n' "$file"
			continue
		fi

		while read -r line; do
			((l++))
			junk=( $line ); w+=${#junk[@]}
			c+=${#line}
		done < $file

		case "$lwc" in
			*c*)	printf '%8d' "$c"; tc+=$c ;;
			*w*)	printf '%8d' "$w"; tw+=$w ;;
			*l*)	printf '%8d' "$l"; tl+=$l ;;
		esac
		printf '%s\n' "$file"
	done

	if [ "${#files[@]}" -gt 1 ]; then
		case "$lwc" in
			*c*)	printf '%8d' "$tc" ;;
			*w*)	printf '%8d' "$tw" ;;
			*l*)	printf '%8d' "$tl" ;;
		esac
		printf 'total\n'
	fi
}

