local Queue = require("queue")

local start_time = os.clock()

local lines = {}
for line in io.lines("11.txt") do
    table.insert(lines, line)
end


local function find_paths(machines, node, paths)
	local num_paths = 0

	if (machines[node]) then
		for _, i in ipairs(machines[node]) do
			if (not paths[i]) then
				machines, paths = find_paths(machines, i, paths)
			end
			num_paths =  num_paths + paths[i]
		end
	end

	paths[node] = num_paths

	return machines, paths
end


-- part 1
local machines = {}
local paths = {}

for _, line in ipairs(lines) do
	local colon = string.find(line, ":")
	local name = string.sub(line, 1, colon-1)
	local output_str = string.sub(line, colon+2)

	local outputs = {}
	for match in string.gmatch(output_str, "[^ ]+") do
		table.insert(outputs, match)
	end

	machines[name] = outputs
end

paths["out"] = 1

machines, paths = find_paths(machines, "you", paths)

print("Part 1: " .. paths["you"])


-- part 2
local machines2 = {}

local paths_to_dac = {}
local paths_to_fft = {}
local paths_to_out = {}
local paths_from_svr = {}
local all_paths = nil

for _, line in ipairs(lines) do
	local colon = string.find(line, ":")
	local name = string.sub(line, 1, colon-1)
	local output_str = string.sub(line, colon+2)

	local outputs = {}
	for match in string.gmatch(output_str, "[^ ]+") do
		table.insert(outputs, match)
	end

	machines2[name] = outputs
end

-- find if fft -> dac exists or dac -> fft
-- than run the algo 3 times:
-- a) svg -> fft/dac
-- b) fft/dac -> dac/fft
-- c) dac/fft -> out
-- the number of paths is a * b * c

paths_to_dac["dac"] = 1
paths_to_fft["fft"] = 1
paths_to_out["out"] = 1

_, paths_to_fft = find_paths(machines2, "dac", paths_to_fft)
_, paths_to_dac = find_paths(machines2, "fft", paths_to_dac)

if (paths_to_fft["dac"] > 0) then
	-- dac -> fft exists 
	-- calculate svr -> dac and fft -> out

	paths_from_svr["dac"] = 1
	_, paths_from_svr = find_paths(machines2, "svr", paths_from_svr)

	_, paths_to_out = find_paths(machines2, "fft", paths_to_out)

	all_paths = paths_from_svr["srv"] * paths_to_fft["dac"] * paths_to_out["fft"]
elseif (paths_to_dac["fft"] > 0 ) then
	-- fft -> dac exists
	-- calculate srv -> fft and dac -> out

	paths_from_svr["fft"] = 1
	_, paths_from_svr = find_paths(machines2, "svr", paths_from_svr)

	_, paths_to_out = find_paths(machines2, "dac", paths_to_out)

	all_paths = paths_from_svr["svr"] * paths_to_dac["fft"] * paths_to_out["dac"]
end


print("Part 2: " .. all_paths)

local end_time = os.clock()
print("Elapsed time " .. (end_time - start_time) .. " seconds")
