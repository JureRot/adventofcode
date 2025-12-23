start_time = time()
input_file = "05.txt"


function char_distance(a, b)
	abs(Int(a) - Int(b))
end


# part 1
line = readline(input_file)
index = 1

while (index < length(line))
	dist = char_distance(line[index], line[index+1])

	if (dist == 32) # means that the characters are of different case
		global line = line[1:index-1] * line[index+2:end]
		global index = max(1, index-1)
	else
		global index += 1
	end
end

println("Part 1: ", length(line))


# part 2
line2 = readline(input_file)
smalles_length = typemax(Int)
best_char = nothing

for i in 65:90
	stripped_line = replace(line, Char(i) => "") # removes all occurences of char in string
	stripped_line = replace(stripped_line, Char(i+32) => "") #removes all occurences of lowercase char in string

	# this part is same as above
	index2 = 1

	while (index2 < length(stripped_line))
		dist = char_distance(stripped_line[index2], stripped_line[index2+1])

		if (dist == 32)
			stripped_line = stripped_line[1:index2-1] * stripped_line[index2+2:end]
			index2 = max(1, index2-1)
		else
			index2 += 1
		end
	end

	if (length(stripped_line) < smalles_length)
		global smalles_length = length(stripped_line)
		global best_char = i
	end
end

println("Part 2: ", smalles_length)


elapsed_time = time() - start_time
println("Elapsed time:" , elapsed_time, " seconds")
