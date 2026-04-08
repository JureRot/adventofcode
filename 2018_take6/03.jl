start_time = time()

input_file = "03.txt"


# part 1
canvas = Dict()
num_overlapping = 0

for line in eachline(input_file)
	line = replace(line, "#" => "") # remove # at the start
	line = replace(line, " @ " => ";") # replace other delimieters with ;
	line = replace(line, "," => ";") 
	line = replace(line, ": " => ";") 
	line = replace(line, "x" => ";") 
	indexes = split(line, ";")

	id = parse(Int, indexes[1])
	x = parse(Int, indexes[2])
	y = parse(Int, indexes[3])
	w = parse(Int, indexes[4])
	h = parse(Int, indexes[5])

	for i in x:(x+w-1), j in y:(y+h-1)
		if (!haskey(canvas, (i,j)))
			global canvas[(i,j)] = [id]
		else
			push!(canvas[(i,j)], id)
		end
	end
end

for (_, value) in canvas
	if (length(value) > 1)
		global num_overlapping += 1
	end
end

println("Day 3 part 1: ", num_overlapping)


# part 2
# being lazy and reusing part 1
indexes = Dict()
non_overlapping = 0

for (_, value) in canvas
	if (length(value) == 1)
		if (!haskey(indexes, value[1]))
			global indexes[value[1]] = 0
		end
	else
		for i in value
			if (!haskey(indexes, i))
				global indexes[i] = 1
			else
				global indexes[i] += 1
			end
		end
	end
end

for (id, overlapps) in indexes
	if (overlapps == 0)
		global non_overlapping = id
		break;
	end
end

println("Day 3 part 2: ", non_overlapping)

elapsed_time = time() - start_time;
println("Elapsed time: ", elapsed_time, " s")
