#!/usr/bin/env bash

source dictionary.sh
source solutions.sh

select_solution(){
	today=$(date +%s)
	# watch out for timezones
	wordle_epoch=$(date +%s -d 20210619)
	diff=$(( ("${today}" - "${wordle_epoch}") / 86400 ))
	echo $diff
}
solution_index=$(select_solution)
solution="${solutions[solution_index]}"

check_dictionary(){
	if [[ "${dictionary[*]}" =~ ${1} || "${solutions[*]}" =~ ${1} ]]; then
		echo "true"
	else
		echo "false"
	fi
}

check_solution(){
	# Shellcheck warns you to declare arrays
	candidate=()
	solution_chars=()
	# I don't like it	
	mapfile candidate -t < <(echo "${1}" | grep -o . )
	mapfile solution_chars -t < <(echo "${2}" | grep -o . )
	for ((char=0; char<5; char++)); do
		if [[ "${solution_chars[char]}" == "${candidate[char]}" ]]; then
			# green
			# trim candidate[char] because Bash arrays are weird
			printf '\033[0;32m%s\033[0m' "${candidate[char]:0:1}"
		elif [[ "${solution_chars[*]}" =~ ${candidate[char]} ]]; then
			# yellow
			printf '\033[0;33m%s\033[0m' "${candidate[char]:0:1}"
		else
			printf '%s' "${candidate[char]:0:1}"
		fi 
	done
	echo
}

for ((try=0; try<6; try++)); do
	read -r response
	response_lenght="${#response}"
	if [[ "${response_lenght}" == 5 ]]; then
		# up
		echo -ne '\033[1A'
		if [[ "${response}" == "${solution}" ]]; then
			printf '\033[0;32m%s\033[0m\n' "${response}"
			exit 0			
		elif [[ $(check_dictionary "${response}") == "true" ]]; then
			check_solution "${response}" "${solution}"
		else
			# delete line
			echo -ne '\033[2K'
		fi
	else 
		echo -ne '\033[1A\033[2K' 
	fi
done

echo "${solution}"
