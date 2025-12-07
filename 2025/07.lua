local start_time = os.clock()

local lines = {}
for line in io.lines("07.txt") do
    table.insert(lines, line)
end


--[[
local function dfs_iteration(nodes, depth, beam_location, num_worlds)
	if (depth > #nodes) then
		num_worlds = num_worlds + 1
		return nodes, depth, beam_location, num_worlds
	end

	if (nodes[depth][beam_location]) then -- if split
		-- go left
		nodes, _, _, num_worlds = dfs_iteration(nodes, depth+1, beam_location-1, num_worlds)

		-- go right
		nodes, _, _, num_worlds = dfs_iteration(nodes, depth+1, beam_location+1, num_worlds)
	else -- else continue straigh
		nodes, _, _, num_worlds = dfs_iteration(nodes, depth+1, beam_location, num_worlds)
	end

	return nodes, depth, beam_location, num_worlds
end
--]]


-- part 1
local beams = {}
local num_splits = 0

-- find starting position
local start = string.find(lines[1], 'S')
beams[start] = true


for i = 2, #lines do
	-- find all occurences of ^ in line
	-- by finding thefirst and continuing to repeating the search from its index on
	local loc = 1
	while true do
		local x = string.find(lines[i], '^', loc, true)

		-- if no occurences left we break
		if (x==nil) then
			break
		end

		if (beams[x]) then
			num_splits = num_splits + 1
			beams[x] = false
			beams[x-1] = true
			beams[x+1] = true
		end

		loc = x + 1
	end
end

print("Part 1: " .. num_splits)




-- part 2
--[[
-- dfs with reqursion
local num_worlds = 0

-- find starting position
local start2 = string.find(lines[1], 'S')
local nodes = {}
local starting_depth = 1

-- construct nodes
local current_depth = 1
for i = 2, #lines do
	local nodes_found = false
	local current_level = {}

	local loc = 1
	while true do
		local x = string.find(lines[i], '^', loc, true)

		-- if no occurences left we break
		if (x==nil) then
			break
		end

		current_level[x] = true
		nodes_found = true

		loc = x + 1
	end

	if (nodes_found) then
		nodes[current_depth] = current_level
		current_depth = current_depth + 1
	end
end

-- run iterations
nodes, starting_depth, start2, num_worlds = dfs_iteration(nodes, starting_depth, start2, num_worlds)

print("Part 2: " .. num_worlds)

-- WORKS BUT NOT FAST ENOUGH FOR REAL INPUT
--]]

local beams2 = {}
local num_paths = 0
local State = { Empty = 1, Split = 2, Beam = 3}

-- create starting state
for i = 1, #lines[1] do
	local beam = {}
	if (string.sub(lines[1], i, i) == '.') then
		beam.state = State.Empty
		beam.num_parents = 0
	else
		beam.state = State.Beam
		beam.num_parents = 1
	end

	beams2[i] = beam
end

for i = 2, #lines do
	local loc = 1
	while true do
		local x = string.find(lines[i], '^', loc, true)

		-- if no occurences left we break
		if (x==nil) then
			break
		end

		if (beams2[x].state == State.Beam) then
			-- left
			beams2[x-1].state = State.Beam
			beams2[x-1].num_parents = beams2[x-1].num_parents + beams2[x].num_parents

			--right
			beams2[x+1].state = State.Beam
			beams2[x+1].num_parents = beams2[x+1].num_parents + beams2[x].num_parents

			-- reset parent (do after left and right because we need its num_parents)
			beams2[x].state = State.Split
			beams2[x].num_parents = 0
		end

		loc = x + 1
	end
end

for _, v in pairs(beams2) do
	if (v.state == State.Beam) then
		num_paths = num_paths + v.num_parents
	end
end

print("Part 2: " .. num_paths)


local end_time = os.clock()
print("Elapsed time " .. (end_time - start_time) .. " seconds")
