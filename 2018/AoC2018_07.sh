#!/bin/bash

file="./AoC2018_07_input"
#input=$(<AoC2018_07_input)

## part 1

function part_1 () {
	while read -r line; do
		echo "$line"
	done < $file #alternative to read direcly from file instead of from variable
}

part_1
