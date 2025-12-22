start_time = time()

input_file = "01.txt"


# part 1

# alternative form to read lines
#=
lines = readlines(input_file)
for line in lines
	print(line)
end
=#

frequency = 0

for line in eachline(input_file)
	if (line[1] == '+') # characters are inside '', strings are inside ""
		global frequency += parse(Int, line[2:end]) # writing insidea a loop/scope requires global
	else
		global frequency -= parse(Int, line[2:end])
	end
end

println("Part 1: ", frequency)


# part 2

# generate lines array
lines = String[]
for line in eachline(input_file)
	push!(lines, line)
end

frequency2 = 0
visited_frequencies = Set(0) # or Set([0])
found_repeat = false
repeated_frequency = nothing
index = 1

while (!found_repeat)
	if (lines[index][1] == '+')
		global frequency2 += parse(Int, lines[index][2:end])
	else
		global frequency2 -= parse(Int, lines[index][2:end])
	end

	if (frequency2 in visited_frequencies)
		global found_repeat = true
		global repeated_frequency = frequency2
	end

	push!(visited_frequencies, frequency2)

	global index += 1
	if (index > length(lines))
		global index = 1
	end
end

println("Part 2: ", repeated_frequency)

elapsed_time = time() - start_time
println("Elapsed time:" , elapsed_time, " seconds")

