start_time = time()
input_file = "03.txt"


function insert_region!(grid, r)
	start_x = r["x"]
	end_x = r["x"] + r["w"] - 1
	start_y = r["y"]
	end_y = r["y"] + r["h"] - 1

	for i in start_x:end_x, j in start_y:end_y 
		push!(grid[j,i], r["id"])
	end
end

function insert_region2!(grid, regions, r)
	start_x = r["x"]
	end_x = r["x"] + r["w"] - 1
	start_y = r["y"]
	end_y = r["y"] + r["h"] - 1
	id = r["id"]

	for i in start_x:end_x, j in start_y:end_y 
		if (length(grid[j,i]) > 0)
			# is overlapping
			for o in grid[j,i]
				push!(regions[id]["overlaps"], o)
				push!(regions[o]["overlaps"], id)
			end
		end
		push!(grid[j,i], id) 
	end
end


# part 1
regions = Dict()
min_x = typemax(Int)
max_x = 0
min_y = typemax(Int)
max_y = 0
num_overlapping = 0

for line in eachline(input_file)
	replaced_delimiters = replace(line, '#' => "") # remove # at the beginning
	replaced_delimiters = replace(replaced_delimiters, " @ " => ';') # replace string delimiters with char
	replaced_delimiters = replace(replaced_delimiters, ": " => ';') 
	parts = split(replaced_delimiters, [';', ',', 'x']) # so we can use multiple char delimiters to split
	id = parts[1]
	x = parse(Int, parts[2]) + 1 # julia counts from 1
	y = parse(Int, parts[3]) + 1
	w = parse(Int, parts[4])
	h = parse(Int, parts[5])

	global regions[parts[1]] = Dict(
		"id" => id,
		"x" => x,
		"y" => y,
		"w" => w,
		"h" => h
	)

	if (x < min_x)
		global min_x = x
	end
	if ((x+w-1) > max_x) # -1 because the we need remove the starting / the last one is already not counted
		global max_x = x + w - 1
	end
	if (y < min_y)
		global min_y = y
	end
	if ((y+h-1) > max_y)
		global max_y = y + h - 1
	end
end

# create matrix with empty sets
#grid = fill(set(), max_y, max_x) # THIS IS A TRAP. It fills all ofthem with the same set
grid = [Set() for _ in 1:max_y, _ in 1:max_x]

for v in values(regions)
	insert_region!(grid, v)
end

for i in 1:max_x, j in 1:max_y
	if (length(grid[j,i]) > 1)
		global num_overlapping += 1
	end
end

println("Part 1: ", num_overlapping)


# part 2
regions2 = Dict()
max_x = 0
max_y = 0
not_overlapping = nothing

for line in eachline(input_file)
	replaced_delimiters = replace(line, '#' => "") # remove # at the beginning
	replaced_delimiters = replace(replaced_delimiters, " @ " => ';') # replace string delimiters with char
	replaced_delimiters = replace(replaced_delimiters, ": " => ';') 
	parts = split(replaced_delimiters, [';', ',', 'x']) # so we can use multiple char delimiters to split
	id = parts[1]
	x = parse(Int, parts[2]) + 1 # julia counts from 1
	y = parse(Int, parts[3]) + 1
	w = parse(Int, parts[4])
	h = parse(Int, parts[5])

	global regions2[parts[1]] = Dict(
		"id" => id,
		"x" => x,
		"y" => y,
		"w" => w,
		"h" => h,
		"overlaps" => Set()
	)

	if ((x+w-1) > max_x) # -1 because the we need remove the starting / the last one is already not counted
		global max_x = x + w - 1
	end
	if ((y+h-1) > max_y)
		global max_y = y + h - 1
	end
end

# create matrix with empty sets
grid2 = [Set() for _ in 1:max_y, _ in 1:max_x]

for v in values(regions2)
	insert_region2!(grid2, regions2, v)
end

for r in values(regions2)
	if (length(r["overlaps"]) == 0)
		global not_overlapping = r["id"]
		break
	end
end

println("Part 2: ", not_overlapping)


elapsed_time = time() - start_time
println("Elapsed time:" , elapsed_time, " seconds")
