start_time = time()
input_file = "11.txt"


function get_factors(n)
	max_value = floor(Int, √n) # same as floor(sqrt(n))
	# Int is added so it converts from float to Int, since by default it keeps the type

	for i in 2:max_value
		if (n%i == 0)
			return i, n÷i # again to keep integer
		end
	end

	return 1, n
end

function add_prime_layer!(grid, z)
	# take 1 layer below and add right and bottom edge (care for bottom-right corner)

	biggest_sum = typemin(Int)
	best_x = 0
	best_y = 0

	for x in 1:size(grid, 2)-(z-1), y in 1:size(grid, 1)-(z-1)
		sum_value = grid[y, x, (z-1)]

		# add right edge
		for i in 0:(z-1)
			sum_value += grid[y+(z-1), x+i, 1]
		end

		# add bottom edge
		for j in 0:(z-1)-1 # -1 so we dont count bottom-right corner twice
			sum_value += grid[y+j, x+(z-1), 1]
		end

		grid[y, x, z] = sum_value

		if (sum_value > biggest_sum)
			biggest_sum = sum_value
			best_x = y
			best_y = x
		end
	end

	return biggest_sum, best_x, best_y
end

function add_non_prime_layer!(grid, z, a, b)
	# take the b layer and sum it a times (correctly

	biggest_sum = typemin(Int)
	best_x = 0
	best_y = 0

	for x in 1:size(grid, 2)-(z-1), y in 1:size(grid, 1)-(z-1)
		sum_value = 0
		for i in 0:(a-1), j in 0:(a-1)
			sum_value += grid[y+(j*b), x+(i*b), b]
		end

		grid[y, x, z] = sum_value

		if (sum_value > biggest_sum)
			biggest_sum = sum_value
			best_x = y
			best_y = x
		end
	end

	return biggest_sum, best_x, best_y
end


# part 1
line = readline(input_file)
serial_number = parse(Int, line)
biggest_sum = typemin(Int)
best_x = 0
best_y = 0

# generate empty 2 layer matrix
grid = fill(0, 300, 300, 2)

# set all the values
for x in axes(grid, 2) # x an y turned around on purpose
	for y in axes(grid, 1)
		rack_id = x + 10 # x coord + 10
		power_level = rack_id # rack_id
		power_level *= y # * y coord
		power_level += serial_number # + grid serial number
		power_level *= rack_id # * rack_id
		power_level = ((power_level ÷ 100) % 10) # get the hundreds digit
		# integer division by 100 (removes last 2 digits)
		# alternative for ÷ is div(power_level, 100)
		# than % 10 to remove the digits above the remaining 1
		# alternative for % is mod(n, 10)
		power_level -= 5

		#println("$x, $y -> $power_level")
		grid[y,x,1] = power_level
	end
end


# calculate values for 3x3
for x in 1:size(grid, 2)-2, y in 1:size(grid, 1)-2 # double for loop
	sum_value = 0
	for i in 0:2, j in 0:2 # another double for loop
		sum_value += grid[x+i, y+j, 1]
	end

	grid[y, x, 2] = sum_value

	# check if sum biggest yet
	if (sum_value > biggest_sum)
		global biggest_sum = sum_value
		global best_x = y # switched on purpose
		global best_y = x
	end
end

println("Part 1: ", "$best_x,$best_y")


# for part 2 we employ memoization
# if prime get a level below + right and bottom edge
# if not prime get the biggest divisor and sum them accordingly
line2 = readline(input_file)
serial_number2 = parse(Int, line2)
biggest_sum2 = typemin(Int)
best_x2 = 0
best_y2 = 0
best_z2 = 0

# generate empty 3d matrix
grid2 = fill(0, 300, 300, 300)

# set all the values for 1x1 (same as above)
for x in axes(grid2, 2)
	for y in axes(grid2, 1)
		rack_id = x + 10
		power_level = rack_id
		power_level *= y
		power_level += serial_number2
		power_level *= rack_id
		power_level = ((power_level ÷ 100) % 10)
		power_level -= 5

		grid2[y,x,1] = power_level
	end
end

for z in 2:300
	a, b = get_factors(z)

	if (a == 1)
		# is prime
		local_biggest_sum, local_best_x, local_best_y = add_prime_layer!(grid2, z)
	else
		# not prime
		local_biggest_sum, local_best_x, local_best_y = add_non_prime_layer!(grid2, z, a, b)
	end

	if (local_biggest_sum > biggest_sum2)
		global biggest_sum2 = local_biggest_sum
		global best_x2 = local_best_x
		global best_y2 = local_best_y
		global best_z2 = z
	end
end

println("Part 2: ", "$best_y2,$best_x2,$best_z2")


elapsed_time = time() - start_time
println("Elapsed time:" , elapsed_time, " seconds")
