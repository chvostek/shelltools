
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

# Avoid external binaries
# TODO: can we support `-m` option, the multibyte version of `-c`?
function wc.sh {
	local opt="" lwc=""
	local c=0 w=0 l=0 tc=0 tw=0 tl=0
	local -a inp=() junk
	# options: (-[lwc]) (input)
echo "MARK0"
	while getopts lwc opt; do
echo "MARK1"
echo "opt=$opt"
		case "$opt" in
			#l|w|c)	lwc="$lwc$opt" ;;
			l)	lwc="$lwc$opt" ;;
			w)	lwc="$lwc$opt" ;;
			c)	lwc="$lwc$opt" ;;
			*)	printf 'wc: illegal option -- %s\nusage: wc [-lwc] [file ...]\n' "$opt"
				return 1
				;;
		esac
	done
echo "1 lwc=$lwc"
	lwc="${lwc:-lwc}"
echo "2 lwc=$lwc"
#printf 'OPTIND = %s\n' "$OPTIND"
#printf '\t= %s\n' "$@"
#printf '\t0 = %s\n' "$0"
#printf '\t1 = %s\n' "$1"
#printf '\t2 = %s\n' "$2"
	if [ -n "$lwc" ]; then
		shift $((OPTIND - 1))
	fi
#printf '\t0 = %s\n' "$0"
#printf '\t1 = %s\n' "$1"
	if [ $# -eq 0 ]; then
		files=( "-" )
	else
		files=( "$@" )
	fi

	for file in "${files[@]}"; do
		l=0; w=0; c=0
		if [ "$file" = - ]; then
			file="<(cat)"
			file="/dev/stdin"
		elif [ ! -f "$file" ]; then
			printf 'wc: %s: open: No such file or directory\n' "$file"
			continue
		fi

echo "file=$file"
		while read -r line; do
			(( l++ ))
			junk=( $line ); (( w+=${#junk[@]} ))
			(( c+=${#line} ))
		done < $file

		case "$lwc" in
			#*l*)	printf '%8d' "$((10#$l))"; ((tl+=l)) ;;
			#*w*)	printf '%8d' "$((10#$w))"; ((tw+=w)) ;;
			#*c*)	printf '%8d' "$((10#$c))"; ((tc+=c)) ;;
			*l*)	printf '%s\t' "$((10#$l))"; ((tl+=l)) ;;
			*w*)	printf '%s\t' "$((10#$w))"; ((tw+=w)) ;;
			*c*)	printf '%s\t' "$((10#$c))"; ((tc+=c)) ;;
		esac
		printf '%s\n' "$file"
	done

	if [ "${#files[@]}" -gt 1 ]; then
		case "$lwc" in
			*l*)	printf '%8d' "$((10#$tl))" ;;
			*w*)	printf '%8d' "$((10#$tw))" ;;
			*c*)	printf '%8d' "$((10#$tc))" ;;
		esac
		printf 'total\n'
	fi
}

# Add lz4 support to tar in FreeBSD < 11
function tar {
	if [[ "$1" == *f ]] && [ -s "$2" -a "$(uname -s)" = FreeBSD -a "$(uname -r | cut -d. -f1)" -lt 11 ]; then
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

function array_quotefix {
	local inside=false
	test -n "$1" && local -n arr="${1}"
	local buf
	if [[ "${#arr[@]}" -lt 2 ]]; then
		printf 'usage: array_quotefix arrayname\n\n'
		printf 'Modifies arrayname, merging fields (with spaces) enclosed in single quotes.\n'
		printf 'Arrays must obviously have a minimum of two values.\n\n'
		return 1
	fi
	for f in "${!arr[@]}"; do
		if $inside; then
			case "${arr[$f]}" in
			  *"'")
				arr[$f]="${buf:+$buf }${arr[$f]}"
				unset buf
				;;
			esac
		else
			case "${arr[$f]}" in
			  "'"*)
				inside=true
				buf="${buf:+$buf }${arr[$f]}"
				unset arr[$f]
				;;
			esac
		fi
	done
}
