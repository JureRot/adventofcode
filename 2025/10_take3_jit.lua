local Queue = require("queue")
local Fraction = require("fraction")
local bit = require("bit")

local start_time = os.clock()

local lines = {}
for line in io.lines("10.txt") do
    table.insert(lines, line)
end


local function result_to_bits(result)
	local result_string = ""
	for i = 1, #result do
		if (string.sub(result, i, i) == '.') then
			result_string = result_string .. "0"
		elseif (string.sub(result, i, i) == '#') then
			result_string = result_string .. "1"
		end
	end
	return tonumber(result_string, 2)
end

local function button_to_bitmask(button, num_bits)
	local bitmask_str = ""

	-- parse button
	button = string.sub(button, 2, #button-1)
	local buttons = {}
	for match in string.gmatch(button, "[^,]+") do
		buttons[match + 1] = true -- +1 because lua starts counting at 1
	end

	for i = 1, num_bits do
		if (buttons[i]) then
			bitmask_str = bitmask_str .. "1"
		else
			bitmask_str = bitmask_str .. "0"
		end
	end

	return tonumber(bitmask_str, 2)
end

local function apply_mask(bits, mask)
	--return bits ~ mask -- bitwise XOR
	return bit.bxor(bits, mask) -- bitwise XOR
end

local function perform_bfs_iteration(queue, result, masks)
	local found_solution = false
	local current = Queue.remove(queue)
	local new_state = current.state
	local num_steps = current.num_steps

	-- apply mask
	if (current.step ~= nil) then
		new_state = apply_mask(current.state, current.step)
	end

	-- check if result
	if (new_state == result) then
		-- return true if result
		found_solution = true
	else
		-- add new nodes if not result
		num_steps = num_steps + 1
		for _, v in ipairs(masks) do
			local next_step = {
				state = new_state,
				step = v,
				num_steps = num_steps
			}
			Queue.add(queue, next_step)
		end
	end


	return queue, found_solution, num_steps
end

local function bfs(result, masks)
	-- returns the depth of the first solution
	local queue = Queue.new()
	local starting_state = {
		state = 0, -- starting state
		step = nil, -- which mask should be applied
		num_steps = 0 -- number of button presses to get to this state
		-- previous??
	}
	local found_solution = false
	local num_steps = 0

	-- add starting node to queue
	Queue.add(queue, starting_state)

	while (not found_solution) do
		queue, found_solution, num_steps = perform_bfs_iteration(queue, result, masks)
	end

	return num_steps
end

local function buttons_to_matrix(button_str, num_eqs)
	local matrix = {}
	for i = 1, num_eqs do
		matrix[i] = {}
	end

	-- split into individual buttons
	local buttons = {}
	for match in string.gmatch(button_str, "[^ ]+") do
		table.insert(buttons, match)
	end

	for i, button in ipairs(buttons) do
		-- each button split into which equations it effects
		local stripped_button = string.sub(button, 2, #button-1)
		local eqs = {}
		for match in string.gmatch(stripped_button, "[^,]+") do
			local translated_button = tostring(tonumber(match) + 1) -- because lua starts counting with 1
			eqs[translated_button] = true
		end

		-- fill matrix vertically with 1 (if eq is effected) and 0 (if it isnt)
		for j = 1, num_eqs do
			if (eqs[tostring(j)]) then
				matrix[j][i] = 1
			else
				matrix[j][i] = 0
			end
	 	end
	end

	return matrix
end

local function matrix_to_rref(matrix, results)
	-- implementation of gaussian-jordan elimination with fractions
	-- generate helping data strutures to not overwrite original ones
	local mx = {}
	local res = {}
	for i, x in pairs(matrix) do
		mx[i] = {}
		for j, y in pairs(x) do
			mx[i][j] = Fraction.fromInt(y)
		end
	end
	for i, x in ipairs(results) do
		res[i] = Fraction.fromInt(x)
	end

	local free_vars = {}
	local row = 1
	local column = 1

	while (column <= #mx[1]) do
		local pivot = nil
		-- first check column for any 1s to use as pivot
		for i = row, #mx do
			if (math.abs(Fraction.value(mx[i][column])) == 1) then
				pivot = i
				break
			end
		end
		if (pivot == nil) then
			-- if not pivot found try with any non-zero pivot (will need to normalize it later)
			for i = row, #mx do
				if (not Fraction.isZero(mx[i][column])) then
					pivot = i
					break
				end
			end
		end
		if (pivot ~= nil) then -- pivot found
			-- swap rows that pivot is in top (remaining) row
			if (pivot ~= row) then
				local temp_row = mx[row]
				mx[row] = mx[pivot]
				mx[pivot] = temp_row
				local temp_res = res[row]
				res[row] = res[pivot]
				res[pivot] = temp_res
			end

			-- from now on pivot is in mx[row][column]

			-- if pivot is negative invert its whole row
			if (Fraction.value(mx[row][column]) < 0) then
				for i, cell in pairs(mx[row]) do
					mx[row][i] = Fraction.mulByInt(cell, -1)
				end
				res[row] = Fraction.mulByInt(res[row], -1)
			end

			-- normalize pivot totally (to 1, not only to integer)
			if (Fraction.value(mx[row][column]) ~= 1) then
				local ratio = mx[row][column]
				for i, cell in pairs(mx[row]) do
					mx[row][i] = Fraction.div(cell, ratio)
				end
				res[row] = Fraction.div(res[row], ratio)
			end

			-- reduce all rows above and below
			for i = 1, #mx do
				if (i ~= row) then
					local factor = Fraction.div(mx[i][column], mx[row][column])
					for j = 1, #mx[row] do
						mx[i][j] = Fraction.sub(mx[i][j], Fraction.mul(factor, mx[row][j]))
					end
					res[i] = Fraction.sub(res[i], Fraction.mul(factor, res[row]))
				end
			end

			row = row + 1
		else
			-- if no pivot then this column is a free variable
			table.insert(free_vars, column)

			-- normalize this column to int
			for j = 1, #mx do
				if (not Fraction.isWhole(mx[j][column])) then
					local factor = mx[j][column].den
					for i, cell in pairs(mx[j]) do
						mx[j][i] = Fraction.mulByInt(cell, factor)
					end
					res[j] = Fraction.mulByInt(res[j], factor)
				end
			end
		end

		column = column + 1

		--[[
		-- normalize results column to int
		for j = 1, #res do
			if (not Fraction.isWhole(res[j])) then
				print("normalize result")
				for i, cell in pairs(mx[j]) do
					mx[j][i] = Fraction.mulByInt(cell, res[j].den)
				end
				res[j] = Fraction.mulByInt(res[j], res[j].den)
			end
		end
		-- this is better when its done each iteration instead of just once at the end??
		--]]
	end

	return mx, res, free_vars
end

local function generate_cartesian_product(free_vars, joltage)
	local max_res = math.max(unpack(joltage))
	local combinations = {}

	-- generate combination structure
	local current_comb = {}
	for i, _ in ipairs(free_vars) do
		current_comb[i] = 0
	end

	while (true) do
		-- add combination
		local new_combination = {}
		for i, v in ipairs(current_comb) do
			new_combination[free_vars[i]] = v
		end
		table.insert(combinations, new_combination)

		-- always start at the least significant digit
		local digit = #free_vars

		-- while this digit is max value -> resete it to 0 and move the more significant digit
		-- or until you run out of more significant digits
		while (current_comb[digit]==max_res and digit>=0) do
			current_comb[digit] = 0
			digit = digit - 1
		end

		-- if you ran out of digits you are done
		if (digit < 1) then
			break
		end

		-- else increase the value in the corresponding digit for the next iteration
		current_comb[digit] = current_comb[digit] + 1
	end

	return combinations
end

local function perform_calculation(matrix, results, free_var_combination)
	local presses = {}
	local num_columns = #matrix[1]
	local row = 1

	for column = 1, num_columns do
		if (free_var_combination[column]) then
			-- is free var
			presses[column] = Fraction.fromInt(free_var_combination[column])
		else
			-- have pivot (not free var)
			local res = results[row]
			for c = column+1, num_columns do
				if (not Fraction.isZero(matrix[row][c])) then
					res = Fraction.sub(res, Fraction.mulByInt(matrix[row][c], free_var_combination[c]))
					-- because we generate rref matrix all remaining non-nil values are free vars
				end
			end
			res = Fraction.div(res, matrix[row][column])

			-- optimization to stop on negative values
			if (Fraction.value(res) < 0) then
				return nil
			end

			-- optimization to stop on rational numbers (should not happen)
			if (not Fraction.isWhole(res)) then
				return nil
			end

			presses[column] = res
			row = row + 1
		end
	end

	return presses
end


-- part 1
print("Takes a while (~3 sec)")
local num_all_bfs = 0

for _, line in ipairs(lines) do
	local indicators_start, indicators_end = string.find(line, "%[.+%]")
	local joltage_start, joltage_end = string.find(line, "%{.+%}")
	
	local indicators = string.sub(line, indicators_start+1, indicators_end-1)
	local button_str = string.sub(line, indicators_end+2, joltage_start-2)
	-- local joltage_str = string.sub(line, joltage_start+1, joltage_end-1) -- we dont need

	local buttons = {}
	for match in string.gmatch(button_str, "[^ ]+") do
		table.insert(buttons, match)
	end

	local button_masks = {}
	for _, v in ipairs(buttons) do
		table.insert(button_masks, button_to_bitmask(v, #indicators))
	end

	num_all_bfs = num_all_bfs + bfs(result_to_bits(indicators), button_masks)
end

print("Part 1: " .. num_all_bfs)


-- part 2
print("Takes a while (~3 sec)")
-- i have a feeling that bfs (even with prooning) wont work here??
-- so lets try to transfrom the problem in to system of linera equations
-- than use Guassian elimination to get free variables
-- and than bruteforce those free variables
-- link to explanation (https://www.reddit.com/r/adventofcode/comments/1pl8nsa/comment/ntqt12a)
-- another possible solution is to use simplex algorithm (https://www.reddit.com/r/adventofcode/comments/1pl8nsa/comment/ntqt68w)
-- another possible solution without linear algebra including recursion and dynamic programming (https://www.reddit.com/r/adventofcode/comments/1pk87hl)
-- additional problem -> division inpercision. We need to use fractions throughut the process to keep precise values.
-- Additionally we need to extend gaussian elimination to normalize rows and columns so we dont end up with only rational values (we need whole numbers for our solution)
local count_all_presses = 0

for _, line in ipairs(lines) do
	local indicators_start, indicators_end = string.find(line, "%[.+%]")
	local joltage_start, joltage_end = string.find(line, "%{.+%}")
	
	--local indicators = string.sub(line, indicators_start+1, indicators_end-1) -- we dont need
	local button_str = string.sub(line, indicators_end+2, joltage_start-2)
	local joltage_str = string.sub(line, joltage_start+1, joltage_end-1)

	local joltage = {}
	for match in string.gmatch(joltage_str, "[^,]+") do
		table.insert(joltage, tonumber(match))
	end

	-- generate matrix for system of equations
	local matrix = buttons_to_matrix(button_str, #joltage)

	-- transform matrix to reduced row echelon form
	local rref_matrix, rref_joltage, free_vars = matrix_to_rref(matrix, joltage)

	-- generate all possible combinations for free variables
	local combinations = generate_cartesian_product(free_vars, joltage)


	-- execute all combinations of free vars and get the one that results in the least number of presses
	local least_presses = Fraction.fromInt(4294967296)
	for _, comb in ipairs(combinations) do
		local sum_presses = Fraction.fromInt(0)

		local presses = perform_calculation(rref_matrix, rref_joltage, comb)

		if (presses ~= nil) then
			for _, v in pairs(presses) do
				sum_presses = Fraction.add(sum_presses, v)
			end

			if (Fraction.value(sum_presses) < Fraction.value(least_presses)) then
				least_presses = sum_presses
			end
		end
	end

	count_all_presses = count_all_presses + Fraction.value(least_presses)
end

print("Part 2: " .. math.floor(count_all_presses))

local end_time = os.clock()
print("Elapsed time " .. (end_time - start_time) .. " seconds")
