#!/bin/bash

file="./AoC2018_03_input"
#input=$(<AoC2018_03_input)

## part 1

function part_1 () {
	# idea: parse content into associative array (adding values from zero). at the end where value more than 1, we have overlap, so we can loop over and count
	# idea: this is very similar to matrixes or images

	local -A matrix #use associative array as matrix with [x,y] addressing
	# local max_y=0
	# local max_x=0
	# this would be usefull if we needed to recreate the matrix as 2d array, but we dont need that for this solution
	local overlap_counter=0

	while read -r line; do
		#echo "$line"
		line_vars=($(echo "$line" | xargs | cut -d" " -f 1,3,4))
		# xargs removes heading, trailing and excess whitespace (basically it makes it like arguments separated by only one space)u
		# cut splits line into segments by delimiter " " and we want only fields 1,3 and 4 (starting counting from 1 (not 0))
		# parens () make it so the variables are array instead of string

		x=$(echo "${line_vars[1]}" | cut -d"," -f1)
		y=$(echo "${line_vars[1]}" | cut -d"," -f2 | cut -d":" -f1)
		w=$(echo "${line_vars[2]}" | cut -d"x" -f1)
		h=$(echo "${line_vars[2]}" | cut -d"x" -f2)
		# use cut again to parse string

		#for j in $(seq "$x" $((x+w-1))); do # could use seq for for loop
		for (( j="$y"; j<$((y+h)); j++ )); do # use c-style for loop over 2d area
			for (( i="$x"; i<$((x+w)); i++ )); do
				# if new cell, we set else, we increase (which is overlap)
				if [[ "${matrix["$j,$i"]}" ]]; then
					((matrix["$j,$i"]+=1))
				else
					matrix["$j,$i"]=1
				fi

				: '
				# not needed but good to have
				if [[ "$j" -gt "$max_y" ]]; then
					max_y="$j"
				fi
				if [[ "$i" -gt "$max_x" ]]; then
					max_x="$i"
				fi
				'
			done
		done
	done < $file #alternative to read direcly from file instead of from variable

	for i in "${matrix[@]}"; do
		if [[ "$i" -gt 1 ]]; then
			((overlap_counter+=1))
		fi
	done

	printf "solution 1: %i\n" "$overlap_counter"
}

function part_2 () {
	# idea: fill the array with index values and see if any already there. if yes, then remove that index from array of candidates
	# else very similart than part 1

	local -A matrix #use associative array as matrix with [x,y] addressing
	local -a candidates

	while read -r line; do
		line_vars=($(echo "$line" | xargs | cut -d" " -f 1,3,4))
		id=$(echo "${line_vars[0]}" | cut -d"#" -f2)
		x=$(echo "${line_vars[1]}" | cut -d"," -f1)
		y=$(echo "${line_vars[1]}" | cut -d"," -f2 | cut -d":" -f1)
		w=$(echo "${line_vars[2]}" | cut -d"x" -f1)
		h=$(echo "${line_vars[2]}" | cut -d"x" -f2)

		candidates["$id"]="$id" # add id as candidate (the value doestn matter)

		for (( j="$x"; j<$((x+w)); j++ )); do
			for (( i="$y"; i<$((y+h)); i++ )); do
				if [[ "${matrix["$j,$i"]}" ]]; then
					unset candidates["$id"]
					unset candidates["${matrix["$j,$i"]}"]
					matrix["$j,$i"]="$id"
					# if cell already set we have an overlap
					# so we remove both ids (current and the one in the cell) as candidates
					# overwriting the chell with curr id doesnt matter, because that id already removed from candidates
				else
					matrix["$j,$i"]="$id"
				fi
			done
		done
	done < $file
	
	printf "solution 2: %s\n" "${candidates[@]}"
}

part_1
part_2 # very slow (give it few minutes)
