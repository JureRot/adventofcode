start_time = time()

input_file = "06.txt"

function filter_down!(mat)
	for j in 1:size(mat, 1), i in 1:size(mat, 2)
		# up
		if (j > 1)
			up = mat[j-1, i]
			if (up.id != nothing)
				if ((up.distance + 1) < mat[j, i].distance)
					mat[j, i].id = up.id
					mat[j, i].distance = up.distance + 1
				elseif ((up.distance + 1) == mat[j, i].distance)
					if (mat[j ,i].id == nothing || mat[j, i].id == up.id)
						mat[j, i].id = up.id
						mat[j, i].distance = up.distance + 1
					else #same distance
						mat[j, i].id = nothing
						mat[j, i].distance = 0
					end
				end
			end
		end
		# left
		if (i > 1)
			left = mat[j, i-1]
			if (left.id != nothing)
				if ((left.distance + 1) < mat[j, i].distance)
					mat[j, i].id = left.id
					mat[j, i].distance = left.distance + 1
				elseif ((left.distance + 1) == mat[j, i].distance)
					if (mat[j ,i].id == nothing || mat[j, i].id == left.id)
						mat[j, i].id = left.id
						mat[j, i].distance = left.distance + 1
					else #same distance
						mat[j, i].id = nothing
						mat[j, i].distance = 0
					end
				end
			end
		end
		# up left
		if (j > 1 && i > 1)
			upleft = mat[j-1, i-1]
			if (upleft.id != nothing)
				if ((upleft.distance + 2) < mat[j, i].distance)
					mat[j, i].id = upleft.id
					mat[j, i].distance = upleft.distance + 2
				elseif ((upleft.distance + 2) == mat[j, i].distance)
					if (mat[j ,i].id == nothing || mat[j, i].id == upleft.id)
						mat[j, i].id = upleft.id
						mat[j, i].distance = upleft.distance + 2
					else #same distance
						mat[j, i].id = nothing
						mat[j, i].distance = 0
					end
				end
			end
		end
		# up right
		if (j > 1 && i < size(mat, 2))
			upright = mat[j-1, i+1]
			if (upright.id != nothing)
				if ((upright.distance + 2) < mat[j, i].distance)
					mat[j, i].id = upright.id
					mat[j, i].distance = upright.distance + 2
				elseif ((upright.distance + 2) == mat[j, i].distance)
					if (mat[j ,i].id == nothing || mat[j, i].id == upright.id)
						mat[j, i].id = upright.id
						mat[j, i].distance = upright.distance + 2
					else #same distance
						mat[j, i].id = nothing
						mat[j, i].distance = 0
					end
				end
			end
		end
	end

	return mat
end

function filter_up!(mat)
	for j in size(mat, 1):-1:1, i in size(mat, 2):-1:1
		# down
		if (j < size(mat, 1))
			down = mat[j+1, i]
			if (down.id != nothing)
				if ((down.distance + 1) < mat[j, i].distance)
					mat[j, i].id = down.id
					mat[j, i].distance = down.distance + 1
				elseif ((down.distance + 1) == mat[j, i].distance)
					if (mat[j ,i].id == nothing || mat[j, i].id == down.id)
						mat[j, i].id = down.id
						mat[j, i].distance = down.distance + 1
					else #same distance
						mat[j, i].id = nothing
						mat[j, i].distance = 0
					end
				end
			end
		end
		# right
		if (i < size(mat, 2))
			right = mat[j, i+1]
			if (right.id != nothing)
				if ((right.distance + 1) < mat[j, i].distance)
					mat[j, i].id = right.id
					mat[j, i].distance = right.distance + 1
				elseif ((right.distance + 1) == mat[j, i].distance)
					if (mat[j ,i].id == nothing || mat[j, i].id == right.id)
						mat[j, i].id = right.id
						mat[j, i].distance = right.distance + 1
					else #same distance
						mat[j, i].id = nothing
						mat[j, i].distance = 0
					end
				end
			end
		end
		# down right
		if (j < size(mat, 1) && i < size(mat, 2))
			downright = mat[j+1, i+1]
			if (downright.id != nothing)
				if ((downright.distance + 2) < mat[j, i].distance)
					mat[j, i].id = downright.id
					mat[j, i].distance = downright.distance + 2
				elseif ((downright.distance + 2) == mat[j, i].distance)
					if (mat[j ,i].id == nothing || mat[j, i].id == downright.id)
						mat[j, i].id = downright.id
						mat[j, i].distance = downright.distance + 2
					else #same distance
						mat[j, i].id = nothing
						mat[j, i].distance = 0
					end
				end
			end
		end
		# down left
		if (j < size(mat, 1) && i > 1)
			downleft = mat[j+1, i-1]
			if (downleft.id != nothing)
				if ((downleft.distance + 2) < mat[j, i].distance)
					mat[j, i].id = downleft.id
					mat[j, i].distance = downleft.distance + 2
				elseif ((downleft.distance + 2) == mat[j, i].distance)
					if (mat[j ,i].id == nothing || mat[j, i].id == downleft.id)
						mat[j, i].id = downleft.id
						mat[j, i].distance = downleft.distance + 2
					else #same distance
						mat[j, i].id = nothing
						mat[j, i].distance = 0
					end
				end
			end
		end
	end

	return mat
end


# part 1
coordinates = []
coordinate_ids = Set()
min_x = typemax(Int)
max_x = 0
min_y = typemax(Int)
max_y = 0

mutable struct Location 
	id::Union{Int, Nothing}
	distance::Int
end

lines = readlines(input_file)

for i in 1:length(lines)
	split_line = split(lines[i], ", ")
	x = parse(Int, split_line[1])
	y = parse(Int, split_line[2])

	push!(coordinates, [i, x, y])
	push!(coordinate_ids, i)

	if (x < min_x)
		global min_x = x
	end
	if (x > max_x)
		global max_x = x
	end
	if (y < min_y)
		global min_y = y
	end
	if (y > max_y)
		global max_y = y
	end
end

grid = [Location(nothing, typemax(Int)) for j in min_y:max_y, i in min_x:max_x]

for coord in coordinates
	#todo: this needs to include at least half of the diff from min to max
	global grid[(coord[3]-min_y+1), (coord[2]-min_x+1)].id = coord[1]
	global grid[(coord[3]-min_y+1), (coord[2]-min_x+1)].distance = 0
end

# run convolution kernel filter in both directions
filter_down!(grid)
filter_up!(grid)

# check edges to find finite areas (by removing infinite from the set)
for j in 1:size(grid, 1)
	delete!(coordinate_ids, grid[j, 1].id)
	delete!(coordinate_ids, grid[j, size(grid, 2)].id)
end
for i in 1:size(grid, 2)
	delete!(coordinate_ids, grid[1, i].id)
	delete!(coordinate_ids, grid[size(grid, 1), i].id)
end

biggest_area = 0
for id in coordinate_ids
	curr_count = count(x -> x.id == id, grid)
	if (curr_count > biggest_area)
		global biggest_area = curr_count
	end
end

println("Day 6 part 1: ", biggest_area)

elapsed_time = time() - start_time;
println("Elapsed time: ", elapsed_time, " s")
