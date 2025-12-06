local start_time = os.clock()

local lines = {}
for line in io.lines("05.txt") do
    table.insert(lines, line)
end

-- part 1
local num_fresh = 0
local found_empty = false
local fresh = {}

for i = 1, #lines do
	local line = lines[i]

	if (line == "") then
		found_empty = true
		print("switch")
	end

	if (not found_empty) then
		local ranges = {}
		for j in string.gmatch(line, "[^-]+") do
			table.insert(ranges, j)
		end

		for j = ranges[1], ranges[2] do
			fresh[j] = true
		end
	else
		if (fresh[tonumber(line)]) then
			num_fresh = num_fresh + 1
		end
	end
end

print("Part 1: " .. num_fresh)


-- TO SLOW EVEN FOR PART 1


local end_time = os.clock()
print("Elapsed time " .. (end_time - start_time) .. " seconds")