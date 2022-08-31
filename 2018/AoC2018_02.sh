#!/bin/bash

file="./AoC2018_02_input"
input=$(<AoC2018_02_input)

## part 1

function part_1 () {
	# idea: go line by line character by character and have counter for each character and at the end see if any occurred twice or three times
	# ides2 (maybe bash): sort string, count character by character and on character change see if segment lenght was 2 or 3
	# idea3 (maybe bash): sort string, add character on character change (sed) and split by that character, see if lenght of segments 2 or 3
	# https://stackoverflow.com/questions/2373874/how-to-sort-characters-in-a-string

	local doubles=0
	local triples=0

	# read file directly line by line inside of while loop instead of reading it all to a array and looping over that array
	while read -r line; do
		declare -A line_array
		line_array=() # a way of clearing an array (to remove any persisting values from previous loop)

		# go over line and count how many times any character appears in an asociative array
		for i in $(seq 0 $((${#line}-1))); do # seq return a sequence (in this case from 0 to length of line-1)
		#for ((i=0; i<"${#line}"; i++)); do #could use c-style for loop
		if [[ "${line_array[${line:$i:1}]}" ]]; then # this is syntax for substring that starts at character i and is of lenght 1 (e.i. char at index i)
				((line_array[${line:$i:1}]+=1))
			else
				line_array[${line:$i:1}]=1
			fi
		done

		local dbl=0
		local trpl=0

		# go over character count array and see if any appar twice or three times
		for i in "${line_array[@]}"; do
			if [[ "$i" -eq 2 ]]; then
				dbl=1
			fi
			if [[ "$i" -eq 3 ]]; then
				trpl=1
			fi
		done

		: '
		if [[ "$dbl" -eq 1 ]]; then
			((doubles+=1))
		fi
		if [[ "$trpl" -eq 1 ]]; then
			((triples+=1))
		fi
		# we can do it simpler
		'

		# colect that to a value spanning all lines
		((doubles+=dbl))
		((triples+=trpl))

	done <<< "$input"
	# done < $file #alternative to read direcly from file instead of from variable

	local checksum=$((doubles * triples))

	printf "solution 1: %i\n" $checksum

}

## part 2

function part_2 () {
	# idea: levenstein distance (hamming distance because we have same length of the strings)

	IFS=$'\n' read -d '' -a ids <<< "$input"

	for i in $(seq 0 $((${#ids[@]}-1))); do
		for j in $(seq $((i+1)) $((${#ids[@]}-1))); do #dont need to repeat reverse checks
			curr_i=${ids[i]}
			curr_j=${ids[j]}
			differ=-1
			for n in $(seq 0 $((${#curr_i}-1))); do
				if [[ ${curr_i:$n:1} != ${curr_j:$n:1} ]]; then #cant use -eq because that is arithmetic comparison
					if [[ "$differ" -lt 0 ]]; then # first difference is found
						differ="$n"
					else # second difference is found
						differ=-1
						break
					fi
				fi
			done
			# if one difference between strings is found, the index is in differ
			# if none or more than one difference, differ will be -1

			if [[ "$differ" -ge 0 ]]; then
				printf "solution 2: %s%s\n" ${curr_i:0:$differ} ${curr_i:$((differ+1))}
				return
			fi
		done
	done
}

function part_2_take2 () {
	IFS=$'\n' read -d '' -a ids <<< "$input"

	for i in $(seq 0 $((${#ids[@]}-1))); do
		for j in $(seq $((i+1)) $((${#ids[@]}-1))); do #dont need to repeat reverse checks
			curr_i=${ids[i]}
			curr_j=${ids[j]}

			compare=$(cmp -bl <(echo "$curr_i") <(echo "$curr_j"))
			num_lines=$(echo "$compare" | wc -l)

			if [[ "$num_lines" -eq 1 ]]; then
				differ=$(($(echo "$compare" | xargs | cut -d" " -f1)-1))
				printf "solution 2 (take2): %s%s\n" ${curr_i:0:$differ} ${curr_i:$((differ+1))}
				return
			fi
		done
	done
}

part_1
# (bash?)
part_2
# part_2_take2 #simpler but way slower
# (bash2?)
