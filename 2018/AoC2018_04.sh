#!/bin/bash

file="AoC2018_04_input"

function part_1 () {
	local input=$(sort "$file")

	local -A guards #probably simulated 2d array again [guard, minute] (we can overlap multiple day by adding)
	# we can add sum value for guard and run global max so we dont need to loop twice
	local max_minutes=0
	local max_minutes_id=0

	local curr_id=0
	local curr_start=0

	while read -r line; do
		line_vars=( $(echo "$line" | cut -d" " -f 2,4) )
		time=$(echo "${line_vars[0]}" | cut -d":" -f2)
		time="${time//']'}"
		action="${line_vars[1]}"
		action="${action//'#'}"

		# echo "$time $action"
		if [[ "$action" == "asleep" ]]; then
			#echo "start"
			curr_start=${time#0} #save in base 10
		elif [[ "$action" == "up" ]]; then
			#echo "end"
			# printf "guard: %s from %i to %i\n" $curr_id $curr_start $time
			# for (( i="$curr_start"; i<$time; i++ )); do # "08" and "09" interpreted as octal digit (because of leading zero) and is thus not valid number)
			for (( i="$curr_start"; i<${time#0}; i++ )); do #convert to base 10
				# printf "%i " $i
				if [[ ${guards["$curr_id,$i"]} ]]; then
					((guards[$curr_id,$i]+=1))
					#guards["$curr_id,$i"]=1
				else
					guards["$curr_id,$i"]=1
				fi

				: '
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
				if [[ ! ${guards["$curr_id,max"]} ]] || [[ ${guards["$curr_id,$i"]} -gt ${guards["$curr_id,max"]} ]]; then
					guards["$curr_id,max"]="${guards["$curr_id,$i"]}"
					guards["$curr_id,max_id"]="$i"
				fi

			done
			# note of the guard that sleeps the most (so we dont have to loop over all again)
			if [[ ${guards["$curr_id,sum"]} ]]; then
				((guards[$curr_id,sum]+=$(($time-$curr_start))))
			else
				guards["$curr_id,sum"]=$((${time#0}-$curr_start)) # again convert t obase 10
			fi

			if [[ ${guards["$curr_id,sum"]} -gt $max_minutes ]]; then
				max_minutes=${guards["$curr_id,sum"]}
				max_minutes_id=$curr_id
			fi
		else
			#echo "shift change"
			curr_id="$action"
		fi
	done <<< "$input"
	# echo "${!guards[@]}"
	# echo "${guards[@]}"
	# echo "$max_minutes, $max_minutes_id, ${guards[$max_minutes_id,max_id]}"
	printf "solution 1: %d\n" $(($max_minutes_id*${guards[$max_minutes_id,max_id]}))
}

part_1
