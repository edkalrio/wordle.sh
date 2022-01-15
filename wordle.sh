#!/usr/bin/env bash

source dictionary.sh
source solutions.sh
set +x
select_solution(){
	today=$(date +%s)
	wordle_epoch=$(date +%s -d 20210619)
	diff=$(( ("${today}" - "${wordle_epoch}") / 86400 ))
	echo $diff
}
solution_index=$(select_solution)
solution=$(echo "${solutions[solution_index]}")

check_dictionary(){
	if [[ "${dictionary[*]}" =~ "${1}" || "${solutions[*]}" =~ "${1}" ]]; then
		echo "true"
	else
		echo "false"
	# [[ "${dictionary[*]}" =~ "${1}" ]] && echo 'true' || echo 'false'
	fi
}

check_solution(){
	mapfile candidate -t < <(echo "${1}" | grep -o . )
	mapfile solution_chars -t < <(echo "${2}" | grep -o . )
	for ((char=0; char<5; char++)); do
		if [[ "${solution_chars[i]}" == "${candidate[char]}" ]]; then
			printf '\033[0;32m%s\033[0m' "${candidate[char]:0:1}"
		elif [[ "${solution_chars[*]}" =~ "${candidate[char]}" ]]; then
			printf '\033[0;33m%s\033[0m' "${candidate[char]:0:1}"
		else
			printf '%s' "${candidate[char]:0:1}"
		fi 
	done
}

for ((try=0; try<6; try++)); do
	response=""
	read -r response
	response_lenght="${#response}"
	if [[ "${response_lenght}" == 5 ]]; then
		echo -ne '\033[1A'
		if [[ "${response}" == "${solution}" ]]; then
			printf '\033[0;32m%s\033[0m' "${response}"
			echo
			exit 0			
		elif [[ $(check_dictionary "${response}") == "true" ]]; then
			check_solution "${response}" "${solution}"
			echo
		else
			echo "no"
		fi
	else read -r response
	fi
done
