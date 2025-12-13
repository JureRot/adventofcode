local ffi = require("ffi")

local start_time = os.clock()

local lines = {}
for line in io.lines("03.txt") do
    table.insert(lines, line)
end


local function find_biggest(str, start, stop)
    local biggest = 0
    local location = nil

    for i = start, stop do
        local char = tonumber(string.sub(str, i, i))
        if (char > biggest) then
            biggest = char
            location = i

            -- small optimization
            if (biggest == 9) then
                break
            end
        end
    end

    return biggest, location
end


-- part 1
local sum = 0

for i = 1, #lines do
    local joltage = ""
    local line  = lines[i]

    local first, location = find_biggest(line, 1, #line-1)
    joltage = joltage .. first

    local second = find_biggest(line, location+1, #line) -- the second argument will be lost
    joltage = joltage .. second

    sum = sum + joltage
end

print("Part 1: " .. sum)


-- part 2
local sum2 = ffi.new("uint64_t", 0ULL)

for i = 1, #lines do
    local joltage2 = ""
    local line2 = lines[i]
    local n = 12

    local char = nil
    local location = 0

    for j = 1, n do
        char, location = find_biggest(line2, location+1, #line2-(n-j))
        joltage2 = joltage2 .. char
    end

    sum2 = sum2 + tonumber(joltage2)
end

print("Part 2: " .. tostring(sum2))
-- caveat: has ULL at the end signaling unsigned large int type (from C)


local end_time = os.clock()
print("Elapsed time: " .. (end_time - start_time) .. " seconds")
