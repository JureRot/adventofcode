local start_time = os.clock()

local lines = {}
for line in io.lines("03_input.txt") do
	table.insert(lines, line)
end


local function parse_input(line)
	local split = {}
	-- split string by any whitespace (%s)
	for j in string.gmatch(line, "[^%s]+") do
		table.insert(split, j)
	end

	-- remove first character
	local id = string.sub(split[1], 2) -- same as string.sub(split[1], 2, #split[1])

	local location = {}
	-- remove last character and split by ,
	for j in string.gmatch(string.sub(split[3], 1, #split[3]-1), "[^,]+") do
		table.insert(location, j)
	end
	local x = location[1]
	local y = location[2]

	local size = {}
	-- split by x
	for j in string.gmatch(split[4], "[^x]+") do
		table.insert(size, j)
	end
	local w = size[1]
	local h = size[2]

	return {id, x, y, w, h}
end

local function print_canvas(canvas)
	for j = 0, #canvas do
		for i = 0, #canvas[j] do
			io.write((canvas[j][i]))
		end
		print()
	end
end

local function insert_section(canvas, id, x, y, w, h)
	local overlapping = {}
	for j = y, y+h-1 do
		for i = x, x+w-1 do
			if canvas[j][i] == "." then
				canvas[j][i] = id
			else
				-- for part 2
				if canvas[j][i] ~= "X" then
					overlapping[canvas[j][i]] = true
				end
				overlapping[id] = true

				canvas[j][i] = "X"
			end
		end
	end
	return canvas, overlapping
end

-- PART 1
local max_width = 0
local max_height = 0

local inputs = {} -- format: id, x, y, w, h
local canvas = {}
local num_overlapping = 0

-- parse input
for i = 1, #lines do
	local parsed = parse_input(lines[i])

	table.insert(inputs, parsed)

	-- get max sizes
	if parsed[2] + parsed[4] > max_width then
		max_width = parsed[2] + parsed[4]
	end
	if parsed[3] + parsed[5] > max_height then
		max_height = parsed[3] + parsed[5]
	end
end

-- create canvas
for j = 0, max_height do
	canvas[j] = {}
	for i = 0, max_width do
		canvas[j][i] = "."
	end
end

-- insert sections
for i = 1, #inputs do
	-- this function returns 2 values but we ignore the first for part 1
	canvas = insert_section(canvas, inputs[i][1], inputs[i][2], inputs[i][3], inputs[i][4], inputs[i][5])
end

-- count overlaps
for j = 0, #canvas do
	for i = 0, #canvas[j] do
		if canvas[j][i] == "X" then
			num_overlapping = num_overlapping + 1
		end
	end
end

print("Part 1: " .. num_overlapping)


-- PART 2
local max_width2 = 0
local max_height2 = 0

local inputs2 = {} -- format: id, x, y, w, h
local canvas2 = {}
local overlapping = {}

-- parse input
for i = 1, #lines do
	local parsed = parse_input(lines[i])

	table.insert(inputs2, parsed)

	-- get max sizes
	if parsed[2] + parsed[4] > max_width2 then
		max_width2 = parsed[2] + parsed[4]
	end
	if parsed[3] + parsed[5] > max_height2 then
		max_height2 = parsed[3] + parsed[5]
	end
end

-- create canvas
for j = 0, max_height do
	canvas2[j] = {}
	for i = 0, max_width do
		canvas2[j][i] = "."
	end
end

-- insert sections
for i = 1, #inputs do
	local tmp_overlapping
	-- same function call as in part 1 but we make use of the second return value
	canvas2, tmp_overlapping = insert_section(canvas2, inputs[i][1], inputs[i][2], inputs[i][3], inputs[i][4], inputs[i][5])

	overlapping[inputs[i][1]] = false;

	for k, _ in pairs(tmp_overlapping) do
		overlapping[k] = true
	end
end


for k, v in pairs(overlapping) do
	if not v then
		print("Part 2: " .. k)
		break
	end
end

-- part 1 and 2 could be done in one take, but keep the initialization and canvas creation separately for readability


local end_time = os.clock()
print("Elapsed time: " .. (end_time - start_time) ..  " seconds")
