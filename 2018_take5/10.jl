start_time = time()
input_file = "10.txt"


function get_area(min_x, max_x, min_y, max_y)
	return (max_x - min_x) * (max_y - min_y)
end

function perform_iteration!(stars, forward=true)
	factor = 1
	if (!forward)
		factor = -1
	end
	min_x = typemax(Int)
	max_x = typemin(Int)
	min_y = typemax(Int)
	max_y = typemin(Int)

	for i in eachindex(stars)
		stars[i]["x"] += stars[i]["vx"] * factor
		stars[i]["y"] += stars[i]["vy"] * factor

		if (stars[i]["x"] < min_x)
			min_x = stars[i]["x"]
		end
		if (stars[i]["x"] > max_x)
			max_x = stars[i]["x"] 
		end
		if (stars[i]["y"] < min_y)
			min_y = stars[i]["y"] 
		end
		if (stars[i]["y"] > max_y)
			max_y = stars[i]["y"] 
		end
	end

	return get_area(min_x, max_x, min_y, max_y), min_x, max_x, min_y, max_y
end

function create_sky(stars, min_x, max_x, min_y, max_y)
	sky = fill(false, (max_y - min_y)+1, (max_x - min_x)+1)

	for i in stars
		x = i["x"] - (min_x - 1)
		y = i["y"] - (min_y - 1)
		sky[y, x] = true
	end

	for j in axes(sky, 1) # axes() gives the array so is the same as 1:size(sky, 1) (sky() give a number)
		for i in axes(sky, 2)
			if (sky[j,i])
				print('#')
			else
				print('.')
			end
		end
		println()
	end
end
	

# part 1
stars = []

min_x = typemax(Int)
max_x = typemin(Int)
min_y = typemax(Int)
max_y = typemin(Int)
area = typemax(Int)
seconds = 0

for line in eachline(input_file)
	split_line = split(line, ['<', '>', ','])
	x = parse(Int, split_line[2])
	y = parse(Int, split_line[3])
	vx = parse(Int, split_line[5])
	vy = parse(Int, split_line[6])

	# generate stars array
	push!(stars, Dict("x"=>x, "y"=>y, "vx"=>vx, "vy"=>vy))

	# get min and max positions of stars
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

area = get_area(min_x, max_x, min_y, max_y)

# iterate
while (true)
	# set new positions of stars, get new min/max values
	new_area, new_min_x, new_max_x, new_min_y, new_max_y = perform_iteration!(stars)

	# while area is decreasing we keep repeating
	if (new_area > area)
		break
	else
		global area = new_area
		global min_x = new_min_x
		global max_x = new_max_x
		global min_y = new_min_y
		global max_y = new_max_y
	end

	global seconds += 1
end

# need to go one iteration backwards
area, min_x, max_x, min_y, max_y = perform_iteration!(stars, false)

println("Part 1: ")
create_sky(stars, min_x, max_x, min_y, max_y)


# part 2
# unconventionally we reuse part 1
# we just add a counter for part 2
# (we could just as easily copy part 1)

println("Part 2: ", seconds)


elapsed_time = time() - start_time
println("Elapsed time:" , elapsed_time, " seconds")
