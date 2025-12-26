start_time = time()
input_file = "09.txt"

mutable struct Node
	id::Int
	prev::Node
	next::Node

	function Node(id::Int) # custom constructor for first node
		node = new(id)
		node.prev = node
		node.next = node
		return node
	end
end

function marble_insert!(current_node, pos, index)
	# move to the correct spot
	if (pos != 0)
		if (pos > 0)
			# move right
			for i in 1:pos
				current_node = current_node.next
			end
		else
			# move left
			for i in 1:abs(pos)
				current_node = current_node.prev
			end
		end
	end

	# create new node and update links
	new_node = Node(index)

	new_node.prev = current_node
	new_node.next = current_node.next
	current_node.next.prev = new_node
	current_node.next = new_node

	current_node = new_node
	index += 1

	return current_node
end

function marble_remove!(current_node, pos)
	# move to the correct spot
	if (pos != 0)
		if (pos > 0)
			# move right
			for i in 1:pos
				current_node = current_node.next
			end
		else
			# move left
			for i in 1:abs(pos)
				current_node = current_node.prev
			end
		end
	end

	value = current_node.id

	current_node.prev.next = current_node.next
	current_node.next.prev = current_node.prev

	current_node = current_node.next

	return current_node, value
end


# part 1
# implement circular double linked list
line = readline(input_file)
split_line = split(line)
num_players = parse(Int, split_line[1])
num_marbles = parse(Int, split_line[7])
player = 1
#players = zeros(num_players)
players = fill(0, num_players) # same as above, but zeros are floats by default and ints look nicer

current_node = Node(0)

for marble in 1:num_marbles
	if (marble%23 != 0)
		# insert
		global current_node = marble_insert!(current_node, 1, marble)
	else
		#remove
		global players[player] += marble
		global current_node, removed_value = marble_remove!(current_node, -7)
		global players[player] += removed_value
	end
	
	global player += 1
	if (player > num_players) # this could possibly be done better with %
		global player = 1
	end
end

println("Part 1: ", maximum(players))



# part 2
println("Takes a while (16 seconds)")
line2 = readline(input_file)
split_line2 = split(line)
num_players2 = parse(Int, split_line[1])
num_marbles2 = parse(Int, split_line[7]) * 100
player2 = 1
#players = zeros(num_players)
players2 = fill(0, num_players) # same as above, but zeros are floats by default and ints look nicer

current_node2 = Node(0)

for marble in 1:num_marbles2
	if (marble%23 != 0)
		# insert
		global current_node2 = marble_insert!(current_node2, 1, marble)
	else
		#remove
		global players2[player2] += marble
		global current_node2, removed_value = marble_remove!(current_node2, -7)
		global players2[player2] += removed_value
	end
	
	global player2 += 1
	if (player2 > num_players2) # this could possibly be done better with %
		global player2 = 1
	end
end

println("Part 2: ", maximum(players2))

elapsed_time = time() - start_time
println("Elapsed time:" , elapsed_time, " seconds")
