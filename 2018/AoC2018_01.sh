#!/bin/bash

start=`date +%s.%N`
# this is just a way to get formated date text (gets seconds and nanoseconds from Epoch)

input=$(<AoC2018_01_input) #read file to variable
# $(...) get the value of the expression inside (i believe)
# same as cat-ing the file but without calling the cat command

## part 1

function part_1 () {
	# idea: go line by line over input and add it to counter

	counter=0 # this is how we set variables in bash
	# could use local to make this variable only inside this function

	IFS=$'\n' read -d '' -a frequencies <<< "$input"
	# sets internal field separater to new line (because it's done in-line, it doesn't persist but only for next command)
	# than we call the read command that is usually meant to read from stdin to a variable
	# -a flag means we read to numeric array instead of variable
	# -d '' flag means we continue reading until the get to '' instead of stopping at new line (thus we can read multiple lines)
	# instead of reading from stdin we pipe in string using <<< (here-string) (this is similar to << (here-document) and can be understood as piping echoed text to read command echo "$input" | read...)
	# https://en.wikipedia.org/wiki/Here_document
	# https://askubuntu.com/questions/678915/whats-the-difference-between-and-in-bash
	# (do not mistake with > and >> which is writing and appending to files)

	: ' #this is a multiline coment
	[ condition ] is alias for test command that test (exist, is zero, ...) and compares things
	[[ condition ]] is bash improvement of []
	(( something )) batch implementation that performs arithmetic (converts str to int, executes artihtmetic expressions, ...)

	"$variable" gets a value of the variable
	"${#variable}" gets the length of the string
	"${array[index]}" gets the value of index cell of array
	"${array[@]}" gets all values in array
	"${!array[@]}" gets all keys in array
	"${#array[@]}" gets number of items in array

	some additional bash explanations
	https://stackoverflow.com/questions/918886/how-do-i-split-a-string-on-a-delimiter-in-bash
	https://stackoverflow.com/questions/10586153/how-to-split-a-string-into-an-array-in-bash/
	https://unix.stackexchange.com/questions/306111/what-is-the-difference-between-the-bash-operators-vs-vs-vs
	'

	for i in "${frequencies[@]}"; do
		((counter+=i)) # regard i (element in array) as number and add it to counter variable
	done

	echo "solution 1: $counter"
}

function part_1_bash () {
	echo "solution 1 (bash): $((input))" # bash solution for the first part
	# this is possible because ((...)) performs arithemtic operation even if string (so +1 -1 executes as expected)
}


## part 2

function part_2 () {
	# idea: go line by line over input and add frequency as key to an array. repeat until same frequency (key that already exists) is found

	IFS=$'\n' read -d '' -a frequencies <<< "$input"
	freq_len="${#frequencies[@]}"

	declare -A freq_array #decalre associative instead of numeric array (-a flag instead)
	# should use local instead of declare for array as well
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
		if [[ $index -ge "${#frequencies[@]}" ]]; then # restart from the start of the input when come to the end
			index=0
		fi
	done

	echo "solution 2: $counter"
}

function part_2_bash () {
	# idea: use grep or some other type of regex search to find patter in string or file instead of writing keys to array
	# but its too slow for large sets or has a error or limitation somewhere

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

