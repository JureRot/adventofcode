start_time = time()

input_file = "05.txt"


function ascii_distance(a, b)
	return abs(Int(a) - Int(b))
end


# part 1
#=
for line in eachline(input_file)
	println(line)
end
=#
line = readline(input_file)

i = 1
while i < length(line)-1
	if (ascii_distance(line[i], line[i+1]) == 32)
		global line = line[1:i-1] * line[i+2:end]
		global i = max(i-1, 1)
	else
		global i += 1
	end
end

println("Day 5 part 1: ", length(line))


# part 2
line2 = readline(input_file) # not used
smallest_length = typemax(Int)

for c in 65:90
	big = Char(c)
	small = Char(c+32)
	#=
	# regex is slow
	pattern = Regex("[$(big)$(small)]")
	current_line = replace(line, pattern => "")
	# this is slightly better
	current_line = replace(line, big => "")
	current_line = replace(current_line, small => "")
	=#
	# this is best
	current_line = String(filter(c -> c != big && c != small, line))

	#INFO:
	# but the biggest improvement is that we use already collapsed line from part 1
	# instead of the whole input (line2) each time
	# the order (of removing and collapsing) doesnt matter and we should get the same result

	# than bascically part 1
	j = 1
	while j < length(current_line)-1
		if (ascii_distance(current_line[j], current_line[j+1]) == 32)
			current_line = current_line[1:j-1] * current_line[j+2:end]
			j = max(j-1, 1)
		else
			j += 1
		end
	end

	if (length(current_line) < smallest_length)
		global smallest_length = length(current_line)
	end
end

println("Day 5 part 2: ", smallest_length)


elapsed_time = time() - start_time;
println("Elapsed time: ", elapsed_time, " s")
