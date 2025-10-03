local start_time = os.clock()

local lines = {}
for line in io.lines("04_input.txt") do
	table.insert(lines, line)
end

-- we need the input to be sorted
table.sort(lines)

local function parse_line(line)
	local parsed = {}

	local split = {}
	for i in string.gmatch(line, "[^%s]+") do
		table.insert(split, i)
	end

	-- date
	local date_split = {}
	for i in string.gmatch(split[1], "[^-]+") do
		table.insert(date_split, i)
	end
	table.insert(parsed, date_split[3])

	-- hour
	local hour_split = {}
	for i in string.gmatch(split[2], "[^:]+") do
		-- remove the last character
		table.insert(hour_split, string.sub(i, 1, #i-1))
	end
	table.insert(parsed, hour_split[2])

	-- action
	if split[3] == "Guard" then
		table.insert(parsed, "start")

		-- get guard id
		-- remove the first character
		table.insert(parsed, string.sub(split[4], 2)) -- omitting end is same as length of string
	elseif split[3] == "falls" then
		table.insert(parsed, "sleep")
	elseif split[3] == "wakes" then
		table.insert(parsed, "wake")
	end

	-- format: day, hour, action (start, sleep, wake), [guard_id]
	return parsed
end

local function insert_sleep(table, guard, day, start, stop)
	if not table[day] then
		table[day] = {}
	end

	for i = start, stop do
		table[day][i] = guard
	end

	return table
end

-- PART 1
local time_table = {}
local last_guard = nil
local sleep_start_day = nil
local sleep_start_hour = nil

for i = 1, #lines do
	--print(lines[i])
	-- parse line -> day, hour, action, [guard id]
	local parsed = parse_line(lines[i])

	if parsed[3] == "start" then
		last_guard = parsed[4]
	elseif parsed[3] == "sleep" then
		sleep_start_day = parsed[1]
		sleep_start_hour = parsed[2]
	elseif parsed[3] == "wake" then
		time_table = insert_sleep(time_table, last_guard, sleep_start_day, sleep_start_hour, parsed[2]-1)
		sleep_start_hour = nil
	end
end


-- create summed time_table
local summed_time_table = {}

for d, day in pairs(time_table) do
	for i = 0, 59 do
		if day[i] then
			local guard = day[i]
			if not summed_time_table[guard] then
				summed_time_table[guard] = { ["sum"] = 0 }
			end
			if not summed_time_table[guard][i] then
				summed_time_table[guard][i] = 0
			end
			summed_time_table[guard]["sum"] = summed_time_table[guard]["sum"] + 1
			summed_time_table[guard][i] = summed_time_table[guard][i] + 1
		end
	end
end

local most_sum_sleep = 0
local sleepiest_guard = nil
for k, v in pairs(summed_time_table) do
	if v["sum"] > most_sum_sleep then
		most_sum_sleep = v["sum"]
		sleepiest_guard = k
	end
end

local most_sleep_minute = 0
local minute
for k, v in pairs(summed_time_table[sleepiest_guard]) do
	if k ~= "sum" and v > most_sleep_minute then
		most_sleep_minute = v
		minute = k
	end
end

print("Part 1: " .. sleepiest_guard * minute)
-- why does this not work for full input??


local end_time = os.clock()
print("Elapsed time: " .. (end_time - start_time) .. " seconds")
