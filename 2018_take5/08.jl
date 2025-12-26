start_time = time()
input_file = "08.txt"


function parse_nodes!(array, nodes, index)
	original_index = index
	num_children = parse(Int, array[index])
	index += 1
	num_meta = parse(Int, array[index])
	index += 1

	node_children = [] # start index of child
	node_meta = []
	node_value = 0

	for _ in 1:num_children
		push!(node_children, index)
		array, nodes, index = parse_nodes!(array, nodes, index)
	end

	for _ in 1:num_meta
		push!(node_meta, parse(Int, array[index]))
		index += 1
	end

	nodes[original_index] = Dict{String, Any}("children"=>node_children, "meta"=>node_meta)

	return array, nodes, index
end

function calculate_node_values!(nodes, index)
	curr_node = nodes[index]

	if (haskey(curr_node, "value")) # memoization optimization
		#return nodes[index]["value"]
		return curr_node["value"]
	end

	value = 0

	if (length(curr_node["children"]) == 0)
		# if no children just sum of the metadata
		value = sum(curr_node["meta"])
	else
		# each metadata entry represents value of child at for that index to be added
		for i in curr_node["meta"]
			if (checkbounds(Bool, curr_node["children"], i)) # check if index is appropriate
				value += calculate_node_values!(nodes, curr_node["children"][i])
			end
		end
	end

	nodes[index]["value"] = value # memoization optimization
	
	return value
end


# part 1
line = readline(input_file)
nodes = Dict()
index = 1
split_line = split(line)
sum_meta = 0

split_line, nodes, index = parse_nodes!(split_line, nodes, index)

for (k, v) in nodes
	global sum_meta += sum(v["meta"])
end

println("Part 1: ", sum_meta)


# part 2
# unconventionally for part 2 we will use the data structure from part 1 directly
# we will just extend it a bit to make part 2 possible
# we could just as easily redo much of the same thing

root_value = calculate_node_values!(nodes, 1)

println("Part 2: ", root_value)


elapsed_time = time() - start_time
println("Elapsed time:" , elapsed_time, " seconds")
