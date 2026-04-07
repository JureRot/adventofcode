start_time = time()

input_file = "02.txt"


function difference(a, b)
	# assummed all the same length
	diff_counter = 0
	diff_location = 0 # last diff location ("correct" only when only 1 diff)
	for i in 1:length(a)
		if (a[i] != b[i])
			diff_counter += 1
			diff_location = i
		end
	end

	return diff_counter, diff_location
end


# part 1
two_count = 0
three_count = 0

for line in eachline(input_file)
	counts = Dict()
	for c in line
		if (!haskey(counts, c))
			counts[c] = 1
		else
			counts[c] += 1
		end
	end

	two_found = false
	three_found = false
	for (char, count) in counts
		if (count == 2)
			two_found = true
		end
		if (count == 3)
			three_found = true
		end
	end

	if (two_found)
		global two_count += 1
	end
	if (three_found)
		global three_count += 1
	end
end

println("Day 2 part 1: ", two_count*three_count)


# part 2
lines = readlines(input_file)
result = ""

for i in 1:length(lines)-1
	for j in i+1:length(lines)
		diff, loc = difference(lines[i], lines[j])

		if (diff == 1)
			global result = lines[i][1:loc-1] * lines[i][loc+1:end]
			break
		end
	end
end

println("Day 2 part 2: ", result)

elapsed_time = time() - start_time;
println("Elapsed time: ", elapsed_time, " s")
