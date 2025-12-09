local start_time = os.clock()

local lines = {}
for line in io.lines("08.txt") do
    table.insert(lines, line)
end


local function get_dist(a, b)
	local dist = 0

	dist = dist + (a.x - b.x)^2
	dist = dist + (a.y - b.y)^2
	dist = dist + (a.z - b.z)^2
	
	return math.sqrt(dist)
end

local function sort_by_dist(a, b)
	return a.dist < b.dist
end

local function sort_by_size(a, b)
	if (a~=nil and b~=nil) then
		return #a > #b
	elseif (a==nil) then
		return false
	elseif (b==nil) then
		return true
	end
	return false
end

local function make_connection(circuits, switches, a, b)
	local circ_a = switches[a]
	local circ_b = switches[b]

	-- check if alreacy in the same circuit
	if (circ_a == circ_b) then
		return circuits, switches
	end

	-- get all switches in both circuits
	local all_switches = {}
	for _, s in ipairs(circuits[circ_a]) do
		table.insert(all_switches, s)
	end
	for _, s in ipairs(circuits[circ_b]) do
		table.insert(all_switches, s)
	end

	-- put them all together in a new circuit
	local new_circuit_id = #circuits + 1
	local new_circuit = {}
	for _, s in ipairs(all_switches) do
		table.insert(new_circuit, s)
		-- set circuit ids for all switches to the new one (#circuits+1)
		switches[s] = new_circuit_id
	end
	circuits[new_circuit_id] = new_circuit

	-- set all previous circuits (a and b) to nil
	circuits[circ_a] = nil
	circuits[circ_b] = nil

	return circuits, switches
end

local function num_circuits(circuits)
	local count = 0
	for _, v in pairs(circuits) do
		count = count + 1
	end

	return count
end


-- part 1
-- this is a simple (brute force) attempt if we can get by by calculating all distances between all nodes
local coordinates = {}
local distances = {}
local num_connections_made = 1000 -- 10 for sample
local num_connections_checked = 3 
local connection_size_product = 1
local circuits = {} -- circuit_id : { swithc_ids }
local switches = {} -- swithc_id : circuit_id

-- generate all data structures
-- coordinates is a map of all switches with x, y, z coordinates
-- circuits is a map of circuit_id to all switch_ids that are in it
-- switches is a map of switch_id in which ciruit it is
for i, line in ipairs(lines) do
	local coords = {}
	for match in string.gmatch(line, "[^,]+") do
		table.insert(coords, match)
	end

	local temp_x = tonumber(coords[1])
	local temp_y = tonumber(coords[2])
	local temp_z = tonumber(coords[3])

	local coordinate = {
		x = temp_x,
		y = temp_y,
		z = temp_z
	}
	--table.insert(coordinates, coordinate)
	coordinates[i] = coordinate
	circuits[i] = { i }
	switches[i] = i

end

-- calculate all distances between all switches
for i = 1, #coordinates-1 do
	for j = i+1, #coordinates do
		local dist = get_dist(coordinates[i], coordinates[j])
		table.insert(distances, { a = i, b = j, dist = dist })
	end
end


-- sort distances
table.sort(distances, sort_by_dist)

-- for 10 shortest distances perform connections
for i = 1, num_connections_made do
	local distance = distances[i]

	circuits, switches = make_connection(circuits, switches, distance.a, distance.b)
end

-- sort resulting ciruicts by number of switches in it desc
table.sort(circuits, sort_by_size)
-- multiply the lents of 3 larges
for i = 1, num_connections_checked do
	connection_size_product = connection_size_product * #circuits[i]
end

print("Part 1: " .. connection_size_product)


-- part 2
local coordinates2 = {}
local distances2 = {}
local last_connection_x_product = 1
local circuits2 = {}
local switches2 = {}

for i, line in ipairs(lines) do
	local coords = {}
	for match in string.gmatch(line, "[^,]+") do
		table.insert(coords, match)
	end

	local temp_x = tonumber(coords[1])
	local temp_y = tonumber(coords[2])
	local temp_z = tonumber(coords[3])

	local coordinate = {
		x = temp_x,
		y = temp_y,
		z = temp_z
	}
	coordinates2[i] = coordinate
	circuits2[i] = { i }
	switches2[i] = i

end

-- calculate all distances between all switches
for i = 1, #coordinates2-1 do
	for j = i+1, #coordinates2 do
		local dist = get_dist(coordinates2[i], coordinates2[j])
		table.insert(distances2, { a = i, b = j, dist = dist })
	end
end


-- sort distances
table.sort(distances2, sort_by_dist)

-- perform connections until only one circuit
local last_a = nil
local last_b = nil
for i = 1, #distances2 do
	local distance = distances2[i]

	circuits2, switches2 = make_connection(circuits2, switches2, distance.a, distance.b)
	if (num_circuits(circuits2) == 1) then
		last_a = distance.a
		last_b = distance.b
		break
	end
end

-- calculate the product of x coordinates of the last connection made
last_connection_x_product = last_connection_x_product * coordinates2[last_a].x
last_connection_x_product = last_connection_x_product * coordinates2[last_b].x

print("Part 2: " .. last_connection_x_product)


-- BE AN ENGINEER FIRST
-- if there is no need to optimize just solve it using brute force
-- for example here there is no need for octtrees or k-d trees or delaunay triangulation


local end_time = os.clock()
print("Elapsed time " .. (end_time - start_time) .. " seconds")
