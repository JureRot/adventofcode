#!/bin/bash

file="./AoC2018_06_input"
#input=$(<AoC2018_06_input)

## part 1

function part_1 () {
	# idea: dont know how to do the manhatthan distance thingy
	# i guess the most intuitive way would be by creating a 2d array (or an array for each node/character) and go over it with manhatthan distance algorithm, but arrays in bash are a pain in the ass
	# maybe we could manipulate images or use a file as an 2d array (lines are y and characters within a line are x)
	# another problem is with infinite edges and that (i think) we cant just use the smallest concvex envolope around all the nodes, because some areas may extend beyond that
	
	# apparently we have here an example of voronoi diagram, so lets look into that
	# but i dont know if we can easily implement fortune's algorithm
	
	# fuck im dumb !!
	# we can go in reverse. instead of for each node, we find all its closest points, se can go over all points and find its closest node and sum them up
	
	min_x=9999 # declare a random big value for minimal, that will for sure be overwritten
	max_x=-9999 # we do the same for maximum
	min_y=9999
	max_y=-9999

	declare -a nodes_x
	# nodes_x=() # same as above (declares empty indexed array)
	declare -a nodes_y
	# we have array for x and y because its not as easy to have just an array of arrays in bash :(
	declare -a area #-1 means its on the edge (goes to infinity)

	## for part_2
	close_region=0
	region_cutoff=10000

	# we go over nodes and note the locations and extremes (limits / borders)
	while read -r line; do
		IFS=', ' read -r -a line_array <<< "$line" # split lines

		# note the limites of the array
		if [[ ${line_array[0]} -lt $min_x ]]; then
			min_x=${line_array[0]}
		fi
		if [[ ${line_array[0]} -gt $max_x ]]; then
			max_x=${line_array[0]}
		fi
		if [[ ${line_array[1]} -lt $min_y ]]; then
			min_y=${line_array[1]}
		fi
		if [[ ${line_array[1]} -gt $max_y ]]; then
			max_y=${line_array[1]}
		fi

		nodes_x+=(${line_array[0]})
		nodes_y+=(${line_array[1]})
		area+=(0) # dont start with 1, because we will loop over the location of the node as well and will add the 1 then

	done < $file #alternative to read direcly from file instead of from variable

	# we increase our borders by 50% in each direction just to make sure we dont mark any nodes as on the border (so as they go to infinity) if they realy dont
	# we do that by getting the distance between min and max and increase min and max for half of that
	# we do that for x and y dimension
	distance_x=$((max_x-min_x))
	distance_y=$((max_y-min_y))
	half_x=$(((distance_x+2-1)/2))
	# division is rounds down by default, so this is how we get it to round up
	half_y=$(((distance_y+2-1)/2))

	min_x_border=$((min_x-half_x))
	max_x_border=$((max_x+half_x))
	min_y_border=$((min_y-half_y))
	max_y_border=$((max_y+half_y))

	printf "Progress: 0%"

	# we go over each pixel (y and x from border to border)
	for i in $(seq $min_y_border $max_y_border); do
	#for ((i=$min_y_border; i<=$max_y_border; i++)); do # or c-style for loop
		printf "\rProgress: %i%%" $(((((min_y_border-i)*-1)*100)/(max_y_border-min_y_border))) # this is echoed for progress status, because this function is not the fastest
		# its a bit fancy with the percent and \r to rewrite over the previous output line
		for j in $(seq $min_x_border $max_x_border); do
			closest_distance=$((distance_x*2+distance_y*2)) # semi arbitrary starting distance (should be overwritten during the iteration over nodes)
			closest_node=-1
			another_closest=0

			## for part_2
			distance_sum=0

			# we go over all nodes and calculate the distance to the current pixel
			for n in $(seq 0 $((${#nodes_x[@]}-1))); do
				diff_x=$((${nodes_x[$n]}-$j))
				diff_y=$((${nodes_y[$n]}-$i))
				distance=$((${diff_x#-}+${diff_y#-}))

				if [[ $distance -eq $closest_distance ]]; then
					# if two or more nodes are at the same distance to the pixel, we note that (because that pixel does not count towards any node than)
					closest_node=-1
					another_closest=1
				elif [[ $distance -lt $closest_distance ]]; then
					# if this node is the closest to the pixel we not that (and reset the another_closes flag)
					closest_distance=$distance
					closest_node=$n
					another_closest=0
				fi

				distance_sum=$((distance_sum+distance))
			done

			if [[ $j -eq $min_x_border || $j -eq $max_x_border || $i -eq $min_y_border || $i -eq $max_y_border ]]; then
				# if this pixel is on the border we set the area of the closes node to -1
				# this is a way of noting that this node is on the border and that it goes to infinity (thus has infinite area and is of no interest to us for this problem)
				area[$closest_node]=-1
			else
				if [[ ${area[$closest_node]} -ne -1 ]]; then
					# only if there is no other node with the same distance to the pixel we count this pixel towards the closest node
					area[$closest_node]=$((${area[$closest_node]}+1))
				fi
			fi

			## for part_2
			if [[ $distance_sum -lt $region_cutoff ]]; then
				close_region=$(($close_region+1))
			fi
		done
	done

	most_area=0
	# we go over all areas for the nodes and get the largest one
	for i in ${area[@]};do
		if [[ $i -gt $most_area ]]; then
			most_area=$i
		fi
	done

	printf "\nsolution 1: %i\n" $most_area
	printf "solution 2: %i\n" $close_region
}

part_1
# part_2 is part of part_1
