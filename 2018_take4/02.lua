local start_time = os.clock()

local lines = {}
for line in io.lines("02_input.txt") do
	table.insert(lines, line)
end

-- part 1
local doubles = 0
local triples = 0

for i = 1, #lines do
	local counters = {}
	local str = lines[i]
	for s = 1, #str do
		local char = string.sub(str, s, s)
		if not counters[char] then
			counters[char] = 1
		else
			counters[char] = counters[char] + 1
		end
	end

	local has_doubles = false
	local has_triples = false
	for _, v in pairs(counters) do
		if v==2 then
			has_doubles = true
		end
		if v==3 then
			has_triples = true
		end
	end

	if has_doubles then
		doubles = doubles + 1
	end
	if has_triples then
		triples = triples + 1
	end
end

print("Part 1: " .. (doubles * triples))


-- part 2
local matched_string = ""

for i = 1, #lines-1 do
	for j = i+1, #lines do
		local diff_count = 0
		local a = lines[i]
		local b = lines[j]
		for s = 1, #a do
			if string.sub(a, s, s) ~= string.sub(b, s, s) then
				diff_count = diff_count + 1
				if diff_count > 1 then
					break
				end
			end
		end
		if diff_count == 1 then
			for s = 1, #a do
				if string.sub(a, s, s) == string.sub(b, s, s) then
					matched_string = matched_string .. string.sub(a, s, s)
				end
			end
		end
	end
end

print("Part 2: " .. matched_string)

local end_time = os.clock()
print("Elapsed time: " .. (end_time - start_time) ..  " seconds")
