local start_time = os.clock()

local lines = {}
for line in io.lines("01.txt") do
	table.insert(lines, line)
end

local function parse_line(line)
	local command = string.sub(line, 1, 1)
	local count = string.sub(line, 2) -- to the end
	return command, count
end


-- part 1
local dial = 50
local num_zeros = 0

for i = 1, #lines do
	local command, count = parse_line(lines[i])

	if command=="L" then
		count = count * -1
	end

	dial = dial + count
	dial = dial % 100

	-- check if landed on zero
	if dial==0 then
		num_zeros = num_zeros + 1
	end
end

print("Part 1: " .. num_zeros)


-- part 2
local dial2 = 50
local num_any_zeros = 0

for i = 1, #lines do
	local command, count = parse_line(lines[i])

	if command=="L" then
		count = count * -1
	end

	local temp_dial2 = dial2 + count

	-- check if multiple crosses
	-- local crosses = math.abs(dial2 - temp_dial2) // 100 -- works but LuaJIT throws an error
	local crosses = math.floor(math.abs(dial2 - temp_dial2) / 100)
	if crosses>0 then
		num_any_zeros = num_any_zeros + crosses
		if (temp_dial2 < 0) then
			temp_dial2 = temp_dial2 + (100*crosses)
		else
			temp_dial2 = temp_dial2 - (100*crosses)
		end
	end

	-- check if ending on the other side
	-- skip if dial2 start at 0, because than it didnt cross
	if (dial2~= 0 and (temp_dial2>100 or temp_dial2<0)) then
		num_any_zeros = num_any_zeros + 1
	end

	temp_dial2 = temp_dial2 % 100

	-- check if landed on 0
	if (temp_dial2==0)  then
		num_any_zeros = num_any_zeros + 1
	end

	dial2 = temp_dial2
end

print("Part 2: " .. num_any_zeros)

local end_time = os.clock()
print("Elapsed time: " .. (end_time - start_time) ..  " seconds")
