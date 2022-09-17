#!/bin/bash

file="AoC2018_05_input"
# input=$(<AoC2018_05_input)

## part 1

function part_1 () {
	# idea: regex find and replace the pattern and repeat until lenght stays the same (sed)
	# need to generate the regex for all letters aA|Aa|bB|Bb ... (would be easier if we could capture regex group and match upper or lowercase of the group, but dont know how)
	# we could work with variables but for exercise lets write to files

	local temp_file="AoC2018_05_input_temp"
	cp $file $temp_file # create new file that will be manipulated
	# create name of helper file and copy input into that file
	# (this is so we dont mess up the original input data, because we will manipulate text in the temp file)

	## COMMENT FROM HERE ON ->

	# echo $(wc -c "$temp_file" | cut -d" " -f1) # number of bytes
	# echo $(wc -c < "$temp_file") # without the filename
	# echo $(wc -m < "$temp_file") # number of characters (including end-of-line character)

	re=""
	for i in {a..z}; do
		re+="$i${i^}\|${i^}$i\|"
	done
	# we create a pattern of "aA|Aa|bB|Bb...." that will match any two same characters of differnt case (upper, lower)
	# we could hard-code type it out, but doing it programmatically is more fun
	# we need to escape the pipe (|) character
	re="${re::-2}" #substing to the second-to-last character (basically removing the last two characters (last escaped pipe character)

	local file_len=$(wc -m < "$temp_file")

	while [[ true ]]; do
		echo $(sed "s/$re//g" $temp_file) > $temp_file
		# we use sed command to find and replace
		# we replace with nothin thus removing the matched characters
		# we can read and write directly from and to file
		# sed has an -E flag for regular expression but we dont need it here (works just fine without)

		curr_file_len=$(wc -m < "$temp_file")
		# we use the wc command to count the characters in the file (lenght of the file)
		# -m flag counts the number of characters (intlucing end-of-line character)
		# < flag outputs the result without file name (so we dont have to pipe to  'cut -d" " -f1'
		# we coult also use -c flag that counts the number of bytes instead of characters (but each ascii character is one byte)

		# if length of file hasent changed (there was no find and replace) we break whole while loop, else we note current file length
		if [[ "$curr_file_len" -lt "$file_len" ]]; then
			file_len="$curr_file_len"
		else
			break
		fi
	done

	printf "solution 1: %i\n" $((file_len-1))
}


## part 2

function part_2 () {
	# idea: loop over all letters and first remove that letter than do the same as part 1 and keep track using global variable

	local temp_file="AoC2018_05_input_temp"

	cp $file $temp_file # create new file that will be manipulated

	local min=$(wc -m < "$temp_file")
	local min_char=""

	re=""
	for i in {a..z}; do
		re+="$i${i^}\|${i^}$i\|"
	done
	re="${re::-2}"

	for i in {a..z}; do
		cp $file $temp_file # create new file that will be manipulated
		echo $(sed "s/$i\|${i^}//g" $temp_file) > $temp_file
		# we loop over all character and first remove all occurences of that character (upper or lowercase) in the input (we again use sed command)
		# than its the same as part 1

		local file_len=$(wc -m < "$temp_file")

		while [[ true ]]; do
			echo $(sed "s/$re//g" $temp_file) > $temp_file

			curr_file_len=$(wc -m < "$temp_file")

			if [[ "$curr_file_len" -lt "$file_len" ]]; then
				file_len="$curr_file_len"
			else
				break
			fi
		done

		printf "%s -> %i\n" "$i" "$file_len"

		if [[ $((file_len-1)) -lt "$min" ]]; then
			min=$((file_len-1))
			min_char="$i"
		fi
	done

	printf "solution 2: %i\n" "$min"
}

part_1
part_2 # takes about 10 minutes to i echo for each letter (as a status of sorts)
