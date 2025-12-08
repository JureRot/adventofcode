local start_time = os.clock()

local lines = {}
for line in io.lines("06.txt") do
    table.insert(lines, line)
end


-- todo make this with metatables and metamethods
local input_methods = {}

function input_methods:sum()
	local s = 0
	for _, v in ipairs(self) do
		s = s + v
	end
	return s
end

function input_methods:mul()
	local m = 1
	for _, v in ipairs(self) do
		m = m * v
	end
	return m
end
-- And this is a better way of using metatables for this example
-- here we override the __index metamethod which is triggered when you are trying to access an element that does not exist
-- and because tablename[element] == tablename.element we can use this for our advantage
-- instead of just returning nil for a non-set element it will now look if there is metamethod that says what to do
-- and because methods are values in lua it triggers a method
-- input_methods:sum(...) is a short hand for input_methods.sum(self, ...)
-- and so you can use metamethods to make tables behave somewhat more like objects



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
				setmetatable(inputs[j], { __index = input_methods })
            end
            table.insert(inputs[j], tonumber(split_line[j]))
        end
    else
        -- perform operations
        for j = 1, #split_line do
            if (split_line[j] == '+') then
                sum = sum + inputs[j]:sum()
            elseif (split_line[j] == '*') then
                sum = sum + inputs[j]:mul()
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
        counter = counter + 1 -- increase column counter
    else
        if (not inputs2[counter]) then
            inputs2[counter] = {}
			setmetatable(inputs2[counter], { __index = input_methods })
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
        sum2 = sum2 + inputs2[i]:sum()
    elseif (split_operators[i] == '*') then
        sum2 = sum2 + inputs2[i]:mul()
    end
end

print("Part 2: " .. sum2)


local end_time = os.clock()
print("Elapsed time " .. (end_time - start_time) .. " seconds")
