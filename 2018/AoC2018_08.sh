#!/bin/bash

file="./AoC2018_08_input"
#input=$(<AoC2018_0._input)

## part 1

function part_1 () {
	# idea: 
	while read -r line; do
		echo "$line"
	done < $file #alternative to read direcly from file instead of from variable


	printf "solution 1: %s\n" "bla"
}

part_1
