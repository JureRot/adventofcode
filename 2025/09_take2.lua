local start_time = os.clock()

local lines = {}
for line in io.lines("09.txt") do
    table.insert(lines, line)
end


local function get_area(a, b)
	local x_diff = math.abs(a.x - b.x) + 1
	local y_diff = math.abs(a.y - b.y) + 1
	return x_diff * y_diff
end

local function sort_by_area_desc(a, b)
	return a.area > b.area
end

local function connect_tiles(grid, vertical_edges, Colors, a, b)
	if (a.x == b.x) then -- y connection
		local x = a.x
		for y = math.min(a.y, b.y)+1, math.max(a.y, b.y)-1 do
			if (not grid[y]) then
				grid[y] = {}
			end
			grid[y][x] = Colors.Green
		end

		local vertical_edge = {
			y_min = math.min(a.y, b.y),
			y_max = math.max(a.y, b.y),
			x = a.x
		}
		table.insert(vertical_edges, vertical_edge)
	elseif (a.y == b.y) then -- x connection
		local y = a.y
		for x = math.min(a.x, b.x)+1, math.max(a.x, b.x)-1 do
			grid[y][x] = Colors.Green
		end
	end

	return grid
end

local function scanline_fill(grid, vertical_edges, Colors, min_x, max_x, min_y, max_y)
	for j = min_y, max_y do
		local active_edges = {}

		for _, v in ipairs(vertical_edges) do
			if (j>=v.y_min and j<v.y_max) then
				active_edges[v.x] = true
			end
		end

		local current_state = Colors.Other
		for i = min_x, max_x do
			if (active_edges[i]) then
				-- switch/flip state
				if (current_state == Colors.Other) then
					current_state = Colors.Green
				elseif (current_state == Colors.Green) then
					current_state = Colors.Other
				end
			end

			if (grid[j][i] == nil and current_state == Colors.Green) then
				grid[j][i] = current_state
			end
		end
	end
end

-- this could be optimized to look only if borders have any nil/other values not the entire area, but its ok
local function check_whole_area_valid(grid, Colors, a, b)
	for j = math.min(a.y, b.y), math.max(a.y, b.y) do
		for i = math.min(a.x, b.x), math.max(a.x, b.x) do
			if (grid[j][i] == nil) then
				return false
			end
		end
	end

	return true
end


-- part 1
local red_tiles = {}
local areas = {}

for _, line in ipairs(lines) do
	local coords = {}
	for match in string.gmatch(line, "[^,]+") do
		table.insert(coords, match)
	end

	table.insert(red_tiles, {x = coords[1], y = coords[2] })
end

-- calculate all areas
for i = 1, #red_tiles-1 do
	for j = i+1, #red_tiles do
		local area = get_area(red_tiles[i], red_tiles[j])
		table.insert(areas, { a = i, b = j, area = area })
	end
end

-- sort by area descending
table.sort(areas, sort_by_area_desc)

print("Part 1: " .. areas[1].area)


-- part 2
-- implement cooridinate compression
-- use scan-line polygon fill algo to fill the algo
-- maybe optimize checking if area valid (only check borders, not entire area??)
-- 
local red_tiles2 = {}
local min_x = math.maxinteger
local max_x = 0
local min_y = math.maxinteger
local max_y = 0
local Colors = { Red = 1, Green = 2, Other = 3}
local grid = {}
local vertical_edges = {}
local areas2 = {}
local unique_x_set = {}
local unique_x = {}
local unique_x_inverted = {}
local unique_y_set = {}
local unique_y = {}
local unique_y_inverted = {}

for _, line in ipairs(lines) do
	local coords = {}
	for match in string.gmatch(line, "[^,]+") do
		table.insert(coords, match)
	end

	local curr_x = tonumber(coords[1])
	local curr_y = tonumber(coords[2])

	unique_x_set[coords[1]] = true
	--unique_x_set[coords[1]+1] = true -- easier for visualization
	unique_y_set[coords[2]] = true
	--unique_y_set[coords[2]+1] = true

	table.insert(red_tiles2, {x = curr_x, y = curr_y })
end

-- generate mapings for compressed coordinates
for k, _ in pairs(unique_x_set)do
	table.insert(unique_x, tonumber(k))
end
table.sort(unique_x)
for k, v in ipairs(unique_x)do
	unique_x_inverted[v] = k
end

for k, _ in pairs(unique_y_set)do
	table.insert(unique_y, tonumber(k))
end
table.sort(unique_y)
for k, v in ipairs(unique_y)do
	unique_y_inverted[v] = k
end

-- set min and max values of grid
min_x = unique_x_inverted[unique_x[1]]
max_x = unique_x_inverted[unique_x[#unique_x]]
min_y = unique_y_inverted[unique_y[1]]
max_y = unique_y_inverted[unique_y[#unique_y]]

-- generate grid with connected red tiles
local prev_tile = nil
for i = 1, #red_tiles2 do
	local tile = red_tiles2[i]
	local working_x = unique_x_inverted[tile.x]
	local working_y = unique_y_inverted[tile.y]
	local current_tile = { x = working_x, y = working_y }

	if (not grid[working_y]) then
		grid[working_y] = {}
	end

	-- set the tile to red
	grid[working_y][working_x] = Colors.Red
	
	-- connect the current tile to the previous one with green tiles
	if (prev_tile ~= nil) then
		connect_tiles(grid, vertical_edges, Colors, prev_tile, current_tile)
		-- do i not need to cast the result into the same variables??
		-- are the grid and vertical_edges global??
	end

	-- set the previous tile for the next iteration
	prev_tile = { x = working_x, y = working_y }
end
-- connect the last tile to the first one
local first_working_x = unique_x_inverted[red_tiles2[1].x]
local first_working_y = unique_y_inverted[red_tiles2[1].y]
connect_tiles(grid, vertical_edges, Colors, prev_tile, { x = first_working_x, y = first_working_y })

-- fill all remaining rows if dont exist (we dont need this)
for j = min_y, max_y do
	if (not grid[j]) then
		grid[j] = {}
		print("fill row")
	end
end

-- fill the inside of the loop with green tiles
scanline_fill(grid, vertical_edges, Colors, min_x, max_x, min_y, max_y)

-- calculate all areas
for i = 1, #red_tiles2-1 do
	local a = red_tiles2[i]
	local a_working_x = unique_x_inverted[a.x]
	local a_working_y = unique_y_inverted[a.y]
	local working_a = { x = a_working_x, y = a_working_y }
	for j = i+1, #red_tiles2 do
		local b = red_tiles2[j]
		local b_working_x = unique_x_inverted[b.x]
		local b_working_y = unique_y_inverted[b.y]
		local working_b = { x = b_working_x, y = b_working_y }

		-- check if any tile in area not red or green
		if (check_whole_area_valid(grid, Colors, working_a, working_b)) then
			local area = get_area(red_tiles2[i], red_tiles2[j]) -- use real values here
			table.insert(areas2, { a = i, b = j, area = area })
		end
	end
end

-- sort by area descending
table.sort(areas2, sort_by_area_desc)

print("Part 2: " .. areas2[1].area)


local end_time = os.clock()
print("Elapsed time " .. (end_time - start_time) .. " seconds")
