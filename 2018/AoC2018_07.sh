#!/bin/bash

file="./AoC2018_07_input"
#input=$(<AoC2018_07_input)

## part 1

function part_1 () {
	# idea: create associateive array of dependencies for each step
	# go over steps alphabetically and check if has 0 dependcies
	# add that step to order and remove that step as dependency from all other steps
	# repeat
	# (look into how linux apt or pacman resolves this kind of dependencies)
	
	declare -A dependencies=()
	order=""

	while read -r line; do
		# we get the step and the dependency to start that step
		step=$(echo $line | cut -d' ' -f8)
		dependency=$(echo $line | cut -d' ' -f2)

		: '
		if [[ -n "${dependencies[$step]}" ]]; then
			# if this step already has dependencies, we add to it
			dependencies["$step"]="${dependencies[$step]}$dependency"
		else
			# if this step doesnt have any dependencies yet, we create it
			dependencies["$step"]="$dependency"
		fi
		'
		dependencies["$step"]="${dependencies[$step]}$dependency" # but in both cases we can do this so its simpler

		# add the mentioned dependencies as steps as well
		# even if it has no dependcies yet, it must exist as a step
		if [[ ! -n "${dependencies[$dependency]}" ]]; then
			dependencies["$dependency"]=""
		fi
	done < $file #alternative to read direcly from file instead of from variable

	# steps have alphabetical priority, so we sort them
	sorted_keys=$(echo "${!dependencies[@]}" | tr ' ' '\n' | sort | tr '\n' ' ')
	# because sort works on lines (not inline) we transform the spaces into line breaks, sort and transform them back into spaces (so it appears as array)

	while [[ ${#order} -lt ${#dependencies[@]} ]]; do # we repeat until the order is as long as te number of all our steps
		for i in $sorted_keys; do # we go over steps in alphabetical order
			if [[ ${#dependencies[$i]} -eq 0 ]]; then # if step has no dependencies that means its next in order
				order="$order$i" # we add it to order
				sorted_keys=$(echo "$sorted_keys" | tr -d "$i") # we remove it from sorted_keys (so it wont be considered in the next itreation)
				for j in ${!dependencies[@]}; do # we remove it from dependencies for all remaining steps
					dependencies[$j]=$(echo "${dependencies[$j]}" | tr -d "$i")
				done
				break 1 # we break the for loop, so we make sure alphabetical order has priority
			fi
		done
	done

	printf "solution 1: %s\n" $order
}


## part 2

function part_2 () {
	# idea: similar as above, but we iterate over seconds instead of over steps
	# this mean we have few more control variables to keep the step durations
	
	declare -A dependencies=()
	order=""
	num_workers=5
	step_duration=60
	counter=0
	declare -a workers_step
	declare -a workers_ttf # time to finish

	# this part is same as above -> we generate dependencies array and sort the keys
	while read -r line; do
		step=$(echo $line | cut -d' ' -f8)
		dependency=$(echo $line | cut -d' ' -f2)

		dependencies["$step"]="${dependencies[$step]}$dependency"

		if [[ ! -n "${dependencies[$dependency]}" ]]; then
			dependencies["$dependency"]=""
		fi
	done < $file
	sorted_keys=$(echo "${!dependencies[@]}" | tr ' ' '\n' | sort | tr '\n' ' ')

	while [[ ${#order} -lt ${#dependencies[@]} ]]; do
		# first handle/manipulate all workers for this second
		#for i in $(seq 0 $(($num_workers-1))); do
		for (( n=0; n<"$num_workers"; n++)); do
			if [[ -n "${workers_step[$n]}" ]]; then
				workers_ttf[$n]=$((workers_ttf[n]-1)) # decrease ttf for all workers
				if [[ "${workers_ttf[$n]}" == 0 ]]; then # if worker finished (hit 0)
					#add the finished step to order
					order="$order${workers_step[$n]}"

					#remove this step as dependency for other steps
					for j in ${!dependencies[@]}; do
						dependencies[$j]=$(echo "${dependencies[$j]}" | tr -d "${workers_step[$n]}")
					done

					#clear the worker
					workers_step[$n]=""
					workers_ttf[$n]=""
				fi
			fi
		done
		# optimization: if all workers are busy, we can skip next min(ttf) loops

		# then check if any worker can be given a step to do
		for (( n=0; n<"$num_workers"; n++)); do # for each worker
			#if [[ "${workers_step[$n]}" == "" ]]; then 
			if [[ ! -n "${workers_step[$n]}" ]]; then # if worker is not occupied
				for i in $sorted_keys; do # for all remaining steps
					if [[ ${#dependencies[$i]} -eq 0 ]]; then # if step has no dependencies
						step_value=$((step_duration+($(printf "%d" "'$i")-64))) # calculate duration of step from ascii code (printf thingy) and subtract 64 so A becomes 1 and add step_duration

						# occupy the worker with this step
						workers_step[$n]="$i"
						workers_ttf[$n]="$step_value"

						# remove the step from sorted_keys
						sorted_keys=$(echo "$sorted_keys" | tr -d "$i")

						break 1
					fi
				done
			fi
		done

		counter=$((counter+1)) # increase counter
	done

	printf "solution 2: %i\n" $((counter-1)) # need to subtract 1 because in our iteration we add 1 to counter at the end (off-by-one error)
}

part_1
part_2
