#!/bin/bash

file="AoC2018_04_input"

declare -A guards
# simulated 2d array again [guard, minute] (we can overlap multiple days by adding values (0 = awake, >0 = asleep that many times))
# we can add sum value (sum of minutes slept) for guard and keep track of global max so we dont need to loop twice to get the guard that slept the most
# we can also keep track of at which minute the guard sleapt most commonly (max and max_id)
# this needs to be global and outside, so its accessible by part_2 and we dont need to create all over again

## part 1

function part_1 () {
	# idea: firs sort the file. than we can go over it line by line.
	# when new guard starts we note the id
	# when guard falls asleep we note the start of sleep
	# when guard wakes up we loop from start of sleep to end and add those values to the array
	# array is a 2d associative array [guard_id, minute) because all minutes are from 00 to 59
	# at the same time we keep track of sum, max and max_id values for the guard

	local input=$(sort "$file") # we sort the file into variable

	local -A guard_ids #array to keep guard ids (saved as key)
	# this is useful for part 2 because associaative array isnt really 2d array and we make user of array of guards as the first level of array (else we would need to loop over all values)

	# used to find the max so we dont need to loop over array again at the end
	local max_minutes=0
	local max_minutes_id=0

	# used to keep track of which guard and the start of sleep while waiting for wake up entry
	local curr_id=0
	local curr_start=0

	while read -r line; do
		# use cut to parse the data
		line_vars=( $(echo "$line" | cut -d" " -f 2,4) )
		time=$(echo "${line_vars[0]}" | cut -d":" -f2)
		time="${time//']'}"
		# this is a way of removing the ] character
		# its actually find and replace string manipulation method but we replace it with empty string
		action="${line_vars[1]}"
		action="${action//'#'}"


		if [[ "$action" == "asleep" ]]; then
			# when guard falls asleep we note the time of start of sleep
			curr_start=${time#0}
			# this is a way of converting value into decimal system (base 10)
			# the problem is that numbers with leading zero are by default interpreted as octal digit but "08" and "09" are not legal in octal system (base 8)
			# thats why we use this form to convert them into decimal system
		elif [[ "$action" == "up" ]]; then
			# when guard wakes up we can fill in the data from start of sleep till now for the guard
			for (( i="$curr_start"; i<${time#0}; i++ )); do # again convert to base 10
				# if the cell exists (overlap) we increase, else we just set for that minute
				if [[ ${guards["$curr_id,$i"]} ]]; then
					((guards[$curr_id,$i]+=1))
				else
					guards["$curr_id,$i"]=1
				fi

				: '
				# this works but we can join it into one if statement
				if [[ ${guards["$curr_id,max"]} ]]; then
					if [[ ${guards["$curr_id,$i"]} -gt ${guards["$curr_id,max"]} ]]; then
						guards["$curr_id,max"]="${guards["$curr_id,$i"]}"
						guards["$curr_id,max_id"]="$i"
					fi
				else
					guards["$curr_id,max"]="${guards["$curr_id,$i"]}"
					guards["$curr_id,max_id"]="$i"
				fi
				'

				# keeping note of the minute this guard slept most often
				if [[ ! ${guards["$curr_id,max"]} ]] || [[ ${guards["$curr_id,$i"]} -gt ${guards["$curr_id,max"]} ]]; then
					guards["$curr_id,max"]="${guards["$curr_id,$i"]}"
					guards["$curr_id,max_id"]="$i"
				fi

			done

			# keeping note of the amount of time this guard slept
			# again be careful of base 8 digits
			if [[ ${guards["$curr_id,sum"]} ]]; then
				((guards[$curr_id,sum]+=$((${time#0}-$curr_start))))
			else
				guards["$curr_id,sum"]=$((${time#0}-$curr_start))
			fi

			# keeping note of global values which guard slept the most (so we dont need to loop over array at the end)
			if [[ ${guards["$curr_id,sum"]} -gt $max_minutes ]]; then
				max_minutes=${guards["$curr_id,sum"]}
				max_minutes_id=$curr_id
			fi

			# this is for part 2 (so we have an 1d array of the first value in 2d guards array) (quazi structure)
			guard_ids["$curr_id"]=true
			# adding id of this guard to the array as key
			# we can overvwrite if appears multiple times
			# the value of the cell doesnt matter
		else
			# when new guard is apointed for the night we note the guards id
			curr_id="$action"
		fi
	done <<< "$input"

	printf "solution 1: %d\n" $(($max_minutes_id*${guards[$max_minutes_id,max_id]}))

	part_2 "${!guard_ids[@]}"
}

## part 2

function part_2 () {
	# idea: we loop over the array created in part 1 for the guard that slept the most often at the same time and get the minute
	# because we keep note of max and max_id values for each guard in part 1 we dont actualy need to loop over all minutes but just get the values

	ids=("$@")
	# this is how we read array as argument (if we read $1 we would only get first item

	local max=0
	local minute_id=0
	local guard_id=0

	for i in "${ids[@]}"; do
		if [[ "${guards[$i,max]}" -gt $max ]]; then
			max="${guards[$i,max]}"
			minute_id="${guards[$i,max_id]}"
			guard_id="$i"
		fi
	done
	
	printf "solution 2: %d\n" $(($minute_id*$guard_id))
}

part_1
