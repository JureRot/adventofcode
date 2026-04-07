start_time = time()

input_file = "01.txt"

# part 1
frequency = 0

for line in eachline(input_file)
	if (first(line) == '-')
		global frequency -= parse(Int, line[2:end])
	else
		global frequency += parse(Int, line[2:end])
	end
end

println("Day 1 part 1: ", frequency)

# part 2
frequency2 = 0
found_frequencies = Set(frequency2)
found = false

while (!found)
	for line in eachline(input_file)
		if (first(line) == '-')
			global frequency2 -= parse(Int, line[2:end])
		else
			global frequency2 += parse(Int, line[2:end])
		end

		if (frequency2 in found_frequencies)
			global found = true
			break
		else
			push!(found_frequencies, frequency2)
		end
	end
end

println("Day 1 part 2: ", frequency2)

elapsed_time = time() - start_time
println("Elapsed time: ", elapsed_time, " s")
