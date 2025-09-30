local start_time = os.clock()

local lines = {}
for line in io.lines("01_input.txt") do
	table.insert(lines, line)
end

-- part 1
local frequency1 = 0

for i = 1, #lines do
	frequency1 = frequency1 + lines[i]
end

print("Part 1: " .. frequency1)

-- part 2
local counter = 0
local frequency2 = 0
local found_frequencies = {
	["0"] = true
}
local found = false

-- attempt 1 is too slow
--[[
local found_frequencies = { 0 }
local function contains(array, value)
	for i = 1, #array do
		if array[i] == value then
			return true
		end
	end
	return false
end

while (not found) do
	frequency2 = frequency2 + lines[counter % #lines + 1]
	if (contains(found_frequencies, frequency2)) then
		found = true
		break
	end
	--table.insert(found_frequencies, frequency2)
	counter = counter + 1;
end
--]]

-- attempt 2
-- use table as set (with keys as frequencie values and values as true/false/nil)
while (not found) do
	frequency2 = frequency2 + lines[counter % #lines + 1]
	if (found_frequencies[frequency2]) then
		found = true
		break
	end
	found_frequencies[frequency2] = true;
	counter = counter + 1;
end

print("Part 2: " .. frequency2)

local end_time = os.clock()
print("Elapsed time: " .. (end_time - start_time) ..  " seconds")
