start_time = time()
input_file = "06.txt"


function distance_transform!(grid, max_dist)
	# basic 2 pass dp distance transform
	# go from top-left to bottom right and check distances behind you
	# than go from bottom-right to top-left and do the same
	# you should have a map of all distances

	# for j in eachindex(grid) # this doesnt work becaues eachindex returns every element seperately (90 distinct indexes instead of 10x9 indexes)
	#altervative for double for loops
	#=
	for I in CartesianIndices(grid)
		row, column = I.I # I is a caresiand indices object and I returns the row, column tuple
		println("$row $column")
	end
	=#
	# need to do with nested foor
	# could use axes(grid,1) instead of 1:size(grid, 1) but we need to go in reverse also
	# top-left to bottom-right
	for j in 1:size(grid, 1) # 1 means which dimension you want to get
		for i in 1:size(grid, 2)
			# look up and left
			curr_dist = grid[j,i]["dist"]
			up_dist = max_dist
			up_closest = nothing
			left_dist = max_dist
			left_closest = nothing
			if (j>1)
				up_dist =  grid[j-1,i]["dist"] + 1
				up_closest = grid[j-1,i]["closest"]
			end
			if (i>1)
				left_dist =  grid[j,i-1]["dist"] + 1
				left_closest = grid[j,i-1]["closest"]
			end

			if (up_dist<curr_dist || left_dist<curr_dist)
				# neighbors are closer tosource
				if (up_dist < left_dist)
					# up is closer
					grid[j,i]["dist"] = up_dist
					grid[j,i]["closest"] = up_closest
				elseif (left_dist < up_dist)
					# left is closer
					grid[j,i]["dist"] = left_dist
					grid[j,i]["closest"] = left_closest
				else
					# same distance
					# need to check if different
					if (up_closest == left_closest)
						# same candiate -> doestn matter
						grid[j,i]["dist"] = up_dist
						grid[j,i]["closest"] = up_closest
					else
						# different candidate so we set only dist (so it doesnt get overriden)
						grid[j,i]["dist"] = up_dist
						grid[j,i]["closest"] = nothing
					end
				end
			elseif (up_dist==curr_dist || left_dist==curr_dist)
				# at least one of neighbors is same distance
				grid[j,i]["closest"] = nothing
			end
		end
	end

	# bottom-right to top-left
	for j in size(grid, 1):-1:1 # -1 in between means it goes in reverse by 1
		for i in size(grid, 2):-1:1
			# look up and left
			curr_dist = grid[j,i]["dist"]
			down_dist = max_dist
			down_closest = nothing
			right_dist = max_dist
			right_closest = nothing
			if (j<size(grid, 1))
				down_dist = grid[j+1,i]["dist"] + 1
				down_closest = grid[j+1,i]["closest"]
			end
			if (i<size(grid, 2))
				right_dist = grid[j,i+1]["dist"] + 1
				right_closest = grid[j,i+1]["closest"]
			end

			if (down_dist<curr_dist || right_dist<curr_dist)
				# neighbors are closer to source
				if (down_dist < right_dist)
					# down is closer
					grid[j,i]["dist"] = down_dist
					grid[j,i]["closest"] = down_closest
				elseif (right_dist < down_dist)
					# right is closer
					grid[j,i]["dist"] = right_dist
					grid[j,i]["closest"] = right_closest
				else
					# same distance
					# need to check if different
					if (down_closest == right_closest)
						# same candiate -> doestn matter
						grid[j,i]["dist"] = down_dist
						grid[j,i]["closest"] = down_closest
					else
						# different candidate so we set only dist (so it doesnt get overriden)
						grid[j,i]["dist"] = down_dist
						grid[j,i]["closest"] = nothing
					end
				end
			elseif (down_dist==curr_dist || right_dist==curr_dist)
				# at least one of neighbors is same distance
				grid[j,i]["closest"] = nothing
			end
		end
	end
end

function get_distance_to_all!(grid, coords)
	for j in 1:size(grid, 1)
		for i in 1:size(grid, 2)
			dist = 0
			for n in coords
				dist += abs(i - n["x"]) + abs(j - n["y"])
			end
			grid[j,i] = dist
		end
	end
end

# part 1
min_x = typemax(Int)
max_x = 0
min_y = typemax(Int)
max_y = 0
coords = []
coord_areas = Dict()
bigges_area = 0

for line in eachline(input_file)
	split_line = split(line, ", ")
	x = parse(Int, split_line[1])
	y = parse(Int, split_line[2])

	push!(coords, Dict("x" => x, "y" => y))

	global min_x = min(min_x, x)
	global max_x = max(max_x, x)
	global min_y = min(min_y, y)
	global max_y = max(max_y, y)
end

# generate empty grid structure
#grid = [Dict("closest"=>nothing, "dist"=>max(2*max_x, 2*max_y)) for _ in 1:2*max_y, _ in 1:2*max_x]
grid = [Dict("closest"=>nothing, "dist"=>max(2*max_x, 2*max_y)) for _ in 1:max_y, _ in 1:max_x]

for i in eachindex(coords)
	#x = coords[i]["x"] + (max_x÷2)
	x = coords[i]["x"]
	#y = coords[i]["y"] + (max_y÷2)
	y = coords[i]["y"]
	grid[y,x]["closest"] = i
	grid[y,x]["dist"] = 0
end

# execute distance stranform
distance_transform!(grid, max(2*max_x, 2*max_y))

# count areas of regions
for i in eachindex(grid)
	if (!haskey(coord_areas, grid[i]["closest"]))
		coord_areas[grid[i]["closest"]] = 0
	end

	coord_areas[grid[i]["closest"]] += 1
end

# get regions on the edge
infinite_regions = Set()
for i in 1:size(grid, 2)
	push!(infinite_regions, grid[1, i]["closest"])
	push!(infinite_regions, grid[size(grid,1), i]["closest"])
end
for j in 1:size(grid, 1)
	push!(infinite_regions, grid[j, 1]["closest"])
	push!(infinite_regions, grid[j, size(grid,2)]["closest"])
end


# check non-infinite regions which is the largest
for i in keys(coords)
	if (i ∉ infinite_regions) # not element of
	# if (!(i in infinite_regions)) #alternative without unicode
		if (coord_areas[i] > bigges_area)
			global bigges_area = coord_areas[i]
		end
	end
end

println("Part 1: ", bigges_area)


# part 2
# will it be too slow if i brueforce this (aparently not)
min_x2 = typemax(Int)
max_x2	 = 0
min_y2 = typemax(Int)
max_y2 = 0
coords2 = []
area = 0
max_dist2 = 10000 # change to 32 for test data

for line in eachline(input_file)
	split_line = split(line, ", ")
	x = parse(Int, split_line[1])
	y = parse(Int, split_line[2])

	push!(coords2, Dict("x" => x, "y" => y))

	global min_x2 = min(min_x2, x)
	global max_x2 = max(max_x2, x)
	global min_y2 = min(min_y2, y)
	global max_y2 = max(max_y2, y)
end

grid2 = [0 for _ in 1:max_y2, _ in 1:max_x2]

get_distance_to_all!(grid2, coords2)

for i in eachindex(grid2)
	if (grid2[i] < max_dist2)
		global area += 1
	end
end

println("Part 2: ", area)


elapsed_time = time() - start_time
println("Elapsed time:" , elapsed_time, " seconds")
