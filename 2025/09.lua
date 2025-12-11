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

			if (grid[j][i] == Colors.Other and current_state == Colors.Green) then
				grid[j][i] = current_state
			end
		end
	end
end

local function check_area_valid(grid, Colors, a, b)
	for j = math.min(a.y, b.y), math.max(a.y, b.y) do
		for i = math.min(a.x, b.x), math.max(a.x, b.x) do
			if (grid[j][i] == Colors.Other) then
				return false
			end
		end
	end

	return true
end

local function fill_grid(grid, vertical_edges, Colors, min_x, max_x, min_y, max_y)
	-- THIS DOES NOT WORK QUITE RIGHT
	-- scannline fill
	-- need to find all intersections (going from other to green/green or vice versa)
		-- (if previous is other and current is green/red)
	-- fill in between alterating intersections

	-- for each line
	--[[
	for j = min_y, max_y do
		local prev_tile = Colors.Other
		local red_encountered = false
		local fill = false

		for i = min_x, max_x do
			if (grid[j][i] == Colors.Other and (prev_tile==Colors.Green or prev_tile==Colors.Red)) then

				fill = not fill
			end

			prev_tile = grid[j][i]

			if (grid[j][i] == Colors.Other and fill) then
				grid[j][i] = Colors.Green
			end

		end
	end
	--]]
	for j = min_y, max_y do
		local intersections = {}
		local red_encountered = false

		for i = min_x, max_x do
			if (grid[j][i] == Colors.Green and not red_encountered) then
				table.insert(intersections, i)
			end

			if (grid[j][i] == Colors.Red) then
				red_encountered = not red_encountered

				if (not red_encountered) then
					table.insert(intersections, i)
				end
			end
		end

		for _, v in ipairs(intersections) do
			io.write(v .. " ")
		end
		print()
	end

	return grid
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
local red_tiles2 = {}
local min_x = math.maxinteger
local max_x = 0
local min_y = math.maxinteger
local max_y = 0
local Colors = { Red = 1, Green = 2, Other = 3}
local grid = {}
local vertical_edges = {}
local areas2 = {}

for _, line in ipairs(lines) do
	local coords = {}
	for match in string.gmatch(line, "[^,]+") do
		table.insert(coords, match)
	end

	local curr_x = tonumber(coords[1])
	local curr_y = tonumber(coords[2])

	table.insert(red_tiles2, {x = curr_x, y = curr_y })

	if (curr_x < min_x) then min_x = curr_x end
	if (curr_x > max_x) then max_x = curr_x end
	if (curr_y < min_y) then min_y = curr_y end
	if (curr_y > max_y) then max_y = curr_y end
end

print("parsed lines")

-- expand the map for one tile (just for visuals)
min_x = min_x - 1
max_x = max_x + 1
min_y = min_y - 1
max_y = max_y + 1


-- generate grid with connected red tiles
local prev_tile = nil
for i = 1, #red_tiles2 do
	local tile = red_tiles2[i]
	if (not grid[tile.y]) then
		grid[tile.y] = {}
	end

	-- set the tile to red
	grid[tile.y][tile.x] = Colors.Red
	
	-- connect the current tile to the previous one with green tiles
	if (prev_tile ~= nil) then
		connect_tiles(grid, vertical_edges, Colors, prev_tile, tile)
		-- do i not need to cast the result into the same variables??
		-- are the grid and vertical_edges global??
	end

	-- set the previous tile for the next iteration
	prev_tile = tile
end
-- connect the last tile to the first one
connect_tiles(grid, vertical_edges, Colors, prev_tile, red_tiles2[1])

print("generated grid")

-- fill all remaining cells with other color tiles
for j = min_y, max_y do
	for i = min_x, max_x do
		if (not grid[j]) then
			grid[j] = {}
		end
		if (not grid[j][i]) then
			grid[j][i] = Colors.Other
		end
	end
end

print("empty filled grid")

-- fill the inside of the loop with green tiles
scanline_fill(grid, vertical_edges, Colors, min_x, max_x, min_y, max_y)

print("full filled grid")

-- calculate all areas
for i = 1, #red_tiles2-1 do
	for j = i+1, #red_tiles2 do
		local area = get_area(red_tiles2[i], red_tiles2[j])
		
		-- check if whole area on red or green tiles
		if (check_area_valid(grid, Colors, red_tiles2[i], red_tiles2[j])) then
			table.insert(areas2, { a = i, b = j, area = area })
		end
	end
end

print("generated all areas")

-- sort by area descending
table.sort(areas2, sort_by_area_desc)

-- THIS DOES NOT WORK FOR LARGE INPUT

print("Part 2: " .. areas2[1].area)


local end_time = os.clock()
print("Elapsed time " .. (end_time - start_time) .. " seconds")
