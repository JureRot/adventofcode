local start_time = os.clock()

local lines = {}
for line in io.lines("04.txt") do
    table.insert(lines, line)
end


local function apply_filter(grid, y, x)
	-- counts the number of neihbors with roll
	local columns = #grid[y]
	local rows = #grid
	local sum = 0

	for j = math.max(y-1, 1), math.min(y+1, rows) do
		for i = math.max(x-1, 1), math.min(x+1, columns) do
			if (y~=j or x~=i) then
				sum = sum + grid[j][i]
			end
		end
	end

	return sum
end

local function filter3x3(grid)
	-- returns array where each cell with roll in og array has a number of neighbors with roll
	local filtered_grid = {}

	for j = 1, #grid do
		filtered_grid[j] = {}

		for i = 1, #grid[j] do
			if (grid[j][i] == 1) then
				filtered_grid[j][i] = apply_filter(grid, j, i)
			else
				filtered_grid[j][i] = 0
			end

		end
	end

	return filtered_grid
end

local function remove_roll(grid, y, x)
	-- removes a roll and decreases value of all neibhoring cells by 1
	local columns = #grid[y]
	local rows = #grid

	for j = math.max(y-1, 1), math.min(y+1, rows) do
		for i = math.max(x-1, 1), math.min(x+1, columns) do
			if (y~=j or x~=i) then
				grid[j][i] = math.max(grid[j][i]-1, 0)
			else
				grid[j][i] = 0
			end
		end
	end
	return grid
end


-- part 1
local grid = {}
local num = 0

-- parse input into 2d array
for j = 1, #lines do
	local line = lines[j]
	grid[j] = {}

	for i = 1, #line do
		local char = string.sub(line, i, i)

		if (char == '@') then
			grid[j][i] = 1
		else
			grid[j][i] = 0
		end
	end
end

-- generate filtered array
local filtered_grid = filter3x3(grid)

for j = 1, #filtered_grid do
	for i = 1, #filtered_grid[j] do
		if (grid[j][i]==1 and filtered_grid[j][i]<4) then
			num = num + 1
		end
	end
end

print("Part 1: " .. num)


-- part 2
local grid2 = {}
local num_removed = 0
local decreasing = true

-- parse input into 2d array
for j = 1, #lines do
	local line = lines[j]
	grid2[j] = {}

	for i = 1, #line do
		local char = string.sub(line, i, i)

		if (char == '@') then
			grid2[j][i] = 1
		else
			grid2[j][i] = 0
		end
	end
end

-- generate filtered array
local filtered_grid2 = filter3x3(grid2)

-- iterate
while (decreasing) do
	decreasing = false

	-- find all to remove
	local to_remove = {}
	for j = 1, #filtered_grid2 do
		for i = 1, #filtered_grid2[j] do
			if (grid2[j][i]==1 and filtered_grid[j][i]<4) then
				table.insert(to_remove, {j, i})
			end
		end
	end

	-- remove them
	for k, v in pairs(to_remove) do
		grid2[v[1]][v[2]] = 0 -- remove roll in og grid (need it for check to find all to remove)
		filtered_grid = remove_roll(filtered_grid, v[1], v[2]) -- decrease neighbors in filtered array
		num_removed = num_removed + 1
		decreasing = true -- set condition to run until one full iteratin without change
	end
end

print("Part 2: " .. num_removed)


local end_time = os.clock()
print("Elapsed time: " .. (end_time - start_time) .. " seconds")

