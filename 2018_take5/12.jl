start_time = time()
input_file = "12.txt"


function pad_state_fn(state_input)
	state = state_input
	index_change = 0
	# pad beginning
	# first crop to first #
	first_hash = findfirst('#', state)
	index_change = -5 + first_hash
	state = state[first_hash:end]
	#left_pad = 5 - findfirst('#', state)

	for _ in 1:4
		state = "." * state
	end

	# pad end
	# first crop to last #
	last_hash = findlast('#', state)
	state = state[1:last_hash]
	#right_pad = (length(state)+4) - findlast('#', state) 
	for _ in 1:4
		state *= "."
	end

	return state, index_change
end

function get_value_of_state(state,  start_index)
	sum_grown = 0

	for i in eachindex(state)
		if (state[i] == '#')
			pot_index = i + start_index -1 #-1 because julia start counting with 1
			sum_grown += pot_index
		end
	end

	return sum_grown
end


# part 1
lines = readlines(input_file)
initial_state_str = lines[1]
split_initial_state = split(initial_state_str, ": ")
state = split_initial_state[2]
start_index = 0
grow = Set()
no_grow = Set()
sum_grown = 0

# pad state so it has at least 4 . at the beginning and end
padded_start_state, start_index_change = pad_state_fn(state)
state = padded_start_state
start_index += start_index_change

# generate rules
for i in Iterators.drop(eachindex(lines), 2) # drop first 2 indexes
	split_rule = split(lines[i], " => ")

	if (split_rule[2] == "#")
		# grow
		push!(grow, split_rule[1])
	else	
		# no grow
		push!(no_grow, split_rule[1])
	end
end

for _ in 1:20
	new_state_array = ['.', '.']
	for i in 1:length(state)-4
		section = state[i:i+4]

		if section in grow
			push!(new_state_array, '#')
		else
			push!(new_state_array, '.')
		end
	end

	new_state = join(new_state_array, "")
	global state = new_state
	padded_state, index_change = pad_state_fn(state)
	global state = padded_state
	global start_index += index_change
end

# sum all growing puts after 20 iterations
sum_grown = get_value_of_state(state, start_index)

println("Part 1: ", sum_grown)


# part 2
# find if it start convergating to a specific value in terms of change between the generations
# at which point just sum/multiply the remainder
lines2 = readlines(input_file)
initial_state_str2 = lines2[1]
split_initial_state2 = split(initial_state_str2, ": ")
state2 = split_initial_state2[2]
start_index2 = 0
grow2 = Set()
no_grow2 = Set()
curr_value = get_value_of_state(state2, start_index2)
curr_change = 0
no_change = 0
num_iterations = 0
iterations_needed = 50000000000

# pad state so it has at least 4 . at the beginning and end
padded_start_state2, start_index_change2 = pad_state_fn(state2)
state2 = padded_start_state2
start_index2 += start_index_change2

# generate rules
for i in Iterators.drop(eachindex(lines2), 2) # drop first 2 indexes
	split_rule = split(lines2[i], " => ")

	if (split_rule[2] == "#")
		# grow
		push!(grow2, split_rule[1])
	else	
		# no grow
		push!(no_grow2, split_rule[1])
	end
end

while (true)
	new_state_array = ['.', '.']
	for i in 1:length(state2)-4
		section = state2[i:i+4]

		if section in grow2
			push!(new_state_array, '#')
		else
			push!(new_state_array, '.')
		end
	end

	new_state = join(new_state_array, "")
	global state2 = new_state
	padded_state, index_change = pad_state_fn(state2)
	global state2 = padded_state
	global start_index2 += index_change

	global num_iterations += 1
	
	new_value = get_value_of_state(state2, start_index2)
	new_change = new_value - curr_value
	if (new_change == curr_change)
		global no_change += 1
	else
		global no_change = 0
	end

	global curr_value = new_value
	global curr_change = new_change

	# repeat until change between iterations is stable
	if (no_change > 10)
		break
	end
end

# multiply the chnage by the remaining iterations and add it to current value
println("Part 2: ", curr_value + (iterations_needed-num_iterations)*curr_change)


elapsed_time = time() - start_time
println("Elapsed time:" , elapsed_time, " seconds")
