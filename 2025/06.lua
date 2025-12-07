local start_time = os.clock()

local lines = {}
for line in io.lines("06.txt") do
    table.insert(lines, line)
end


-- todo make this with metatables and metamethods
local function sum_all(table)
    local sum = 0
    for i = 1, #table do
        sum = sum + table[i]
    end

    return sum
end
local function mul_all(table)
    local sum = 1
    for i = 1, #table do
        sum = sum * table[i]
    end

    return sum
end


-- part 1
local inputs = {}
local sum = 0

for i = 1, #lines do
    local split_line = {}
    for j in string.gmatch(lines[i], "%S+") do
        table.insert(split_line, j)
    end

    if (split_line[1] ~= '+' and split_line[1] ~= '*') then
        -- fill inputs
        for j = 1, #split_line do
            if (not inputs[j]) then
                inputs[j] = {}
            end
            
            table.insert(inputs[j], tonumber(split_line[j]))
        end
    else
        -- perform operations
        for j = 1, #split_line do
            if (split_line[j] == '+') then
                sum = sum + sum_all(inputs[j])
            elseif (split_line[j] == '*') then
                sum = sum + mul_all(inputs[j])
            end
        end
    end
end

print("Part 1: " .. sum)


-- part 2
local inputs2 = {}
local sum2 = 0
local split_lines = {}
local split_operators = {}

-- split input lines into character arrays (keeping the spaces)
for i = 1, #lines-1 do
    local split_string = {}
    for char in string.gmatch(lines[i], ".") do
        table.insert(split_string, char)
    end
    split_lines[i] =  split_string
end

local counter = 1 --counter for which column we are working on
for i = 1, #split_lines[1] do -- for each column of input
    local all_space = true

    -- if all spaces -> it is deslimiter, we switch switched columns
    for j = 1, #split_lines do
        if (split_lines[j][i] ~= ' ') then
            all_space = false
        end
    end

    if (all_space) then
        counter = counter + 1 -- in crease column counter
    else
        if (not inputs2[counter]) then
            inputs2[counter] = {}
        end

        local temp_string = ""
        -- generate input by column
        -- remember the outer for loop goes by each column of input
        -- and the loop belop goes for each row of input
        -- numbers within the same column belong to the same number
        -- and each each row of input is another digit to the same number
        for j = 1, #split_lines do
            local char = string.sub(lines[j], i, i)
            if (char ~= ' ') then
                temp_string = temp_string .. char
            end
        end

        table.insert(inputs2[counter], temp_string)
    end
end

-- split oprator line
for j in string.gmatch(lines[#lines], "%S+") do
    table.insert(split_operators, j)
end

-- for each operator sum according line
for i = 1, #split_operators do
    if (split_operators[i] == '+') then
        sum2 = sum2 + sum_all(inputs2[i])
    elseif (split_operators[i] == '*') then
        sum2 = sum2 + mul_all(inputs2[i])
    end
end

print("Part 2: " .. sum2)


local end_time = os.clock()
print("Elapsed time " .. (end_time - start_time) .. " seconds")