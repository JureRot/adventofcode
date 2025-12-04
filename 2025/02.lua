local start_time = os.clock()

local lines = {}
for line in io.lines("02.txt") do
	table.insert(lines, line)
end

-- only one line
local line = lines[1]


local function is_invalid_id(n)
	local id = tostring(n)

	-- odd number of digits cant be invalid
	if (#id%2 ~= 0) then
		return false
	end

	local first_half = string.sub(id, 1, #id/2)
	local second_half = string.sub(id, (#id/2)+1)

	if first_half == second_half then
		return true
	end

	return false
end

local function is_invalid_id2(n)
	local id = tostring(n)

	-- build the numbers from the head from 1 to len/2 characters -> compare with og string
	for i = 1, #id/2 do
		if #id%i == 0 then
			--build string
			-- get head
			local head = string.sub(id, 1, i)

			-- create string body
			local body = ""
			for _ = 1, #id/i do
				body = body .. head
			end

			if id == body then
				return true
			end

		end
	end

	return false
end


-- part 1
local ranges = {}
local sum = 0

for i in string.gmatch(line, "[^,]+") do -- split string by ,
	table.insert(ranges, i)
end

for i = 1, #ranges do
	local split = string.find(ranges[i], "-")
	if split==nil then
		break
	end
	local start = tonumber(string.sub(ranges[i], 1, split-1))
	local stop = tonumber(string.sub(ranges[i], split+1))
	-- tonumber() only here to make an int (otherwise it will be a flow in for loop)

	for j = start, stop do
		if is_invalid_id(j) then
			sum = sum + j
		end
	end
end

print("Part 1: " .. sum)


-- part 2
local ranges2 = {}
local sum2 = 0

for i in string.gmatch(line, "[^,]+") do -- split string by ,
	table.insert(ranges2, i)
end

for i = 1, #ranges2 do
	local split = string.find(ranges2[i], "-")
	if split==nil then
		break
	end
	local start = tonumber(string.sub(ranges2[i], 1, split-1))
	local stop = tonumber(string.sub(ranges2[i], split+1))

	for j = start, stop do
		if is_invalid_id2(j) then
			sum2 = sum2 + j
		end
	end
end

print("Part 2: " .. sum2)


local end_time = os.clock()
print("Elapsed time: " .. (end_time - start_time) ..  " seconds")
