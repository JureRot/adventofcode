start_time = time()
input_file = "13.txt"


mutable struct Cart
	x::Int
	y::Int
	direction::Int
	intersections::Int
	crashed::Bool
end

mutable struct Rail
	paths::Dict{Int,Int}
	cart::Union{Nothing, Cart}
	intersection::Bool
end

function parse_char!(line, carts, i, j, char)
	if (char == ' ')
		# not rail nor cart
		push!(line, nothing)
	elseif (char ∈ ['|', '-']) # same as i in []
		# only straight rail
		paths = Dict{Int,Int}()
		if (char == '|')
			paths[0] = 0
			paths[2] = 2
		else
			paths[1] = 1
			paths[3] = 3
		end
		rail = Rail(paths, nothing, false)
		push!(line, rail)
	elseif (char ∈ ['\\', '/'])
		# only curved rail
		paths = Dict{Int,Int}()
		if (char == '/')
			paths[0] = 1
			paths[1] = 0
			paths[2] = 3
			paths[3] = 2
		else
			paths[0] = 3
			paths[1] = 2
			paths[2] = 1
			paths[3] = 0
		end
		rail = Rail(paths, nothing, false)
		push!(line, rail)
	elseif (char == '+')
		# intersection
		paths = Dict{Int,Int}() # dont need to fill them
		rail = Rail(paths, nothing, true)
		push!(line, rail)
	elseif (char ∈ ['^', '>', 'v', '<'])
		paths = Dict{Int,Int}()
		if (char ∈ ['^', 'v'])
			paths[0] = 0
			paths[2] = 2

			if (char == '^')
				cart = Cart(i, j, 0, 0, false)
			else
				cart = Cart(i, j, 2, 0, false)
			end
		else
			paths[1] = 1
			paths[3] = 3

			if (char == '<')
				cart = Cart(i, j, 3, 0, false)
			else
				cart = Cart(i, j, 1, 0, false)
			end
		end

		push!(carts, cart)

		rail = Rail(paths, cart, false)
		push!(line, rail)
	end
end

function move!(map, carts)
	crashes = []

	# sort by y and x
	sort!(carts; by = p -> (p.y, p.x))

	for c in carts
		# dont move crashed carts
		if (c.crashed)
			continue
		end

		# find where cart is moving (target location)
		if (c.direction == 0)
			new_x = c.x
			new_y = c.y-1
		elseif (c.direction == 1)
			new_x = c.x+1
			new_y = c.y
		elseif (c.direction == 2)
			new_x = c.x
			new_y = c.y+1
		elseif (c.direction == 3)
			new_x = c.x-1
			new_y = c.y
		end

		target = map[new_y][new_x]

		# check if target has cart
		if (target.cart == nothing)
			# can move there
			if (target.intersection)

				# determine where we turn
				turn = (c.intersections % 3) - 1
				new_direction = c.direction + turn
				c.intersections += 1

				# remove from curr location
				map[c.y][c.x].cart = nothing

				# add to new location
				target.cart = c

				# set new location and direction of cart
				c.x = new_x
				c.y = new_y
				c.direction = (new_direction + 4) % 4 # to reset negative values
			else
				# determine new direction
				new_direction = target.paths[c.direction]

				# remove from curr location
				map[c.y][c.x].cart = nothing

				# add to new location
				target.cart = c

				# set new location and direction of cart
				c.x = new_x
				c.y = new_y
				c.direction = (new_direction + 4) % 4
			end
		else
			# mark both crashed
			c.crashed = true
			target.cart.crashed = true

			# remove them from map
			map[c.y][c.x].cart = nothing
			map[new_y][new_x].cart = nothing

			# add crash to output
			push!(crashes, [new_x, new_y])
			
		end
	end

	# remove crashed carts
	filter!(x -> !x.crashed, carts)

	return crashes
end

function print_map(map)
	for j in eachindex(map)
		for i in eachindex(map[j])
			cell = map[j][i]

			if (cell == nothing)
				print(" ")
			else
				if (cell.cart == nothing)
					if (cell.intersection)
						print("+")
					else
						print(".")
					end
				else
					if (cell.cart.direction == 0)
						print("^")
					elseif (cell.cart.direction == 1)
						print(">")
					elseif (cell.cart.direction == 2)
						print("v")
					elseif (cell.cart.direction == 3)
						print("<")
					end
				end
			end
		end
		println()
	end
end


# part 1
map = Any[]
carts = []
crashes = []

# up=0, right=1, down=2, left=3

lines = readlines(input_file)

for j in eachindex(lines)
	line = lines[j]
	curr_line = Any[]

	for i in eachindex(line)
		char = line[i]
		parse_char!(curr_line, carts, i, j, char)
	end

	push!(map, curr_line)
end

while (length(crashes) == 0)
	global crashes = move!(map, carts)
end

# print the location of first crash
println("Part 1: ", "$(crashes[1][1]-1),$(crashes[1][2]-1)")


# part 2
map2 = Any[]
carts2 = []
crashes2 = []

# up=0, right=1, down=2, left=3

lines2 = readlines(input_file)

for j in eachindex(lines2)
	line = lines2[j]
	curr_line = Any[]

	for i in eachindex(line)
		char = line[i]
		parse_char!(curr_line, carts2, i, j, char)
	end

	push!(map2, curr_line)
end

# same as above but different end condition
while (length(carts) > 1)
	global crashes = move!(map, carts)
end

# print the location of the last cart
println("Part 2: ", "$(carts[1].x-1),$(carts[1].y-1)")


elapsed_time = time() - start_time
println("Elapsed time:" , elapsed_time, " seconds")
