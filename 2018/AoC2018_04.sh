#!/bin/bash

file="AoC2018_04_input"

function part_1 () {
	local input=$(sort "$file")

	while read -r line; do
		line_vars=( $(echo "$line" | cut -d" " -f 2,4) )
		time=$(echo "${line_vars[0]}" | cut -d":" -f2)
		time="${time//']'}"
		action="${line_vars[1]}"
		action="${action//'#'}"

		echo "$time $action"
	done <<< "$input"
}

part_1
