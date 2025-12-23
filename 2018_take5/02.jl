start_time = time()
input_file = "02.txt"


function compare_strings(a, b)
	changes = Int[]

	if (length(a) != length(b))
		return nothing
	end

	for i in eachindex(a)
		if (a[i] != b[i])
			push!(changes, i)
		end
	end

	return changes
end


# part 1
num_doubles = 0
num_triples = 0

for line in eachline(input_file)
	chars = Dict{Char, Int64}()

	for c in line
		if (!haskey(chars, c))
			chars[c] = 0
		end

		chars[c] += 1
	end
	
	#=
	has_double = false
	has_triple = false

	for (k,v) in chars
		if (v == 2) 3
			has_double = true
		end
		if (v == 3)
			has_triple = true
		end
	end

	if (has_double)
		global num_doubles += 1
	end
	if (has_triple)
		global num_triples += 1
	end
	=#

	# alternative (creates an alternative intermediate collection)
	if (2 in values(chars))
		global num_doubles += 1
	end
	if (3 in values(chars))
		global num_triples += 1
	end

	#=
	# alternative (doesnt create a collection but still O(n), might be faster for large data)
	if any(v -> v == 2, values(chars))
		global num_doubles += 1
	end
	if any(v -> v == 3, values(chars))
		global num_triples += 1
	end
	=#
end

println("Part 1: ", num_doubles * num_triples)


# part 2
# find the hamming distance between the two strings
# return the non-matchign indexes
lines = readlines(input_file)
matching_string = nothing

for i in 1:length(lines)-1, j in i+1:length(lines)
	changes = compare_strings(lines[i], lines[j])

	if (length(changes) == 1)
		# construct string without changed character
		global matching_string = lines[i][1:changes[1]-1] * lines[i][changes[1]+1:end]
		# * is used to concat strings

		break
	end
end

println("Part 2: ", matching_string)


elapsed_time = time() - start_time
println("Elapsed time:" , elapsed_time, " seconds")
