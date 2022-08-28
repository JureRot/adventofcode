#!/bin/bash

start=`date +%s.%N`

input=$(<AoC2018_01_input1) #read file to variable

## part 1

function part_1 () {
	counter=0 #set counter variable with 0

	IFS=$'\n' read -d '' -a frequencies <<< "$input"
	# https://stackoverflow.com/questions/918886/how-do-i-split-a-string-on-a-delimiter-in-bash
	# https://stackoverflow.com/questions/10586153/how-to-split-a-string-into-an-array-in-bash/
	# NEED TO UNDERSTAND WHAT IS HAPPENING
	# > vs >> vs >>>
	# [ vs [[ vs ( vs ((
	# array addressing

	# echo "${#frequencies[@]}"

	for i in "${frequencies[@]}"; do
		# echo "$i"
		# regard string as number and add it to $counter
		((counter+=i))
	done

	echo "solution 1: $counter"
}

function part_1_bash () {
	echo "solution 1 (bash): $((input))" # bash solution for the first part
}


## part 2

function part_2 () {
	IFS=$'\n' read -d '' -a frequencies <<< "$input"
	freq_len="${#frequencies[@]}"

	declare -A freq_array #decalre associative instead of numeric array (-a flag instead)
	# should use local instead of declare
	local index=0
	local counter=0

	freq_array[0]=true

	while [[ true ]]; do
		curr_val="${frequencies[$index]}"
		((counter+=curr_val))

		if [[ "${freq_array[$counter]}" ]]; then
			break
		fi
		freq_array[$counter]=true

		((index+=1))
		if [[ $index -ge "${#frequencies[@]}" ]]; then
			index=0
		fi
	done

	echo "solution 2: $counter"
}

function part_2_bash () {
	: '
	multiline comment
	'

	IFS=$'\n' read -d '' -a frequencies <<< "$input"
	freq_len="${#frequencies[@]}"

	declare -A freq_array #decalre associative instead of numeric array (-a flag instead)
	# should use local instead of declare
	local index=0
	local counter=0
	local found="0"
	local reset=0


	while [[ true ]]; do
		curr_val="${frequencies[$index]}"
		((counter+=curr_val))

		# found=$(echo -e "$found\n$counter")
		#echo "$counter - $found"
		# MAYBE TRY ANOTHER SUBSTRING (awk, sed) OR STRFIND (or writing to file)
		if [[ "$found" =~ (^| )"$counter"($| ) ]]; then
			echo "found"
			break
		fi
		found="$found $counter"

		((index+=1))
		if [[ $index -ge "${#frequencies[@]}" ]]; then
			index=0
			((reset+=1))
		fi


		if [[ $Reset -ge 1 ]];then
			break
		fi

	done

	echo "solution 2 (bash): $counter"
}

part_1
part_1_bash
part_2
# part_2_bash (doesnt work for large number set)

end=`date +%s.%N`
runtime=$(echo "$end - $start" | bc -l) #requires bc command
printf "\n$runtime seconds\n"
# or better yet, just use time command to run the script

exit 0

