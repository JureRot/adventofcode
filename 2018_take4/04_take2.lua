local start_time = os.clock()

local lines = {}
for line in io.lines("04_input.txt") do
	table.insert(lines, line)
end

-- we need the input to be sorted
table.sort(lines)


-- PART 1
for i = 1, #lines do
	print(lines[i])
end


local end_time = os.clock()
print("Elapsed time: " .. (end_time - start_time) .. " seconds")
