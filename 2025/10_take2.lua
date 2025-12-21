local Queue = require("queue")

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
	return bits ~ mask -- bitwise XOR
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

local function buttons_to_equation(button_str, num_variables)
	-- for each variable, which buttons change it
	local equation = {}

	-- parse buttons
	local buttons = {}
	for match in string.gmatch(button_str, "[^ ]+") do
		table.insert(buttons, match)
	end

	for i = 1, num_variables do
		equation[i] = {}
		for j = 1, #buttons do
			equation[i][j] = 0
		end
	end

	for i, b in ipairs(buttons) do
		local button = string.sub(b, 2, #b-1)
		local vars = {}
		for match in string.gmatch(button, "[^,]+") do
			vars[match + 1] = true -- +1 because lua starts counting at 1
		end

		for k, _ in pairs(vars) do
			equation[k][i] = 1
		end
	end

	return equation
end

--[[
function table.clone(tbl)
	return {table.unpack(tbl)}
end
--]]

local function generate_reduced_row_echelon_form(eq, res)
	local free_vars = {}
	local num_vars = #eq[1]
	local row = 1

	for i = 1, num_vars do -- for each variable in equations
		local found_free_var = false

		-- find the pivot
		local pivot = 0
		for j = row, #eq do
			if (eq[j][i] ~= 0) then
				pivot = j
				break
			end
		end

		-- switch the pivot
		if (pivot == 0) then
			table.insert(free_vars, i) -- note: here use i, not row
			found_free_var = true
		elseif (pivot == row) then
		else
			local temp_eq = eq[row]
			eq[row] = eq[pivot]
			eq[pivot] = temp_eq

			local temp_res = res[row]
			res[row] = res[pivot]
			res[pivot] = temp_res
		end


		if (not found_free_var) then
			local p = eq[row][i] -- value of pivot

			-- if pivot is negative invert its whole row
			if (p < 0) then
				for n = i, num_vars do
					eq[row][n] = eq[row][n] * -1
				end
				res[row] = res[row] * -1
				p = p * -1
			end

			-- reduce the rows above and below by the factor difference to pivot row
			for r = 1, #eq do
				if (r ~= row) then
					if (eq[r][i] ~= 0) then
						local rv = eq[r][i] -- row value (value under local pivot)
						local factor = rv // p
						for v = i, num_vars do
							eq[r][v] = eq[r][v] - (factor * eq[row][v])
						end
						res[r] = res[r] - (factor * res[row])
					end
				end
			end

			-- move to the next row
			row = row + 1
		end
	end

	return eq, res, free_vars
end

local function perform_equations(eq, res, free_vars)
	local presses = {}
	local column = 1
	local i = 1
	local num_eq = #eq[1]

	--for i = 1, #eq do
	--while (i <= num_eq) do
	while (column <= num_eq) do
		while (eq[i]==nil or eq[i][column]==0 or free_vars[column]) do
			column = column + 1
			if (column > num_eq) then
				break
			end
			presses[column] = free_vars[column]
		end

		if (column > num_eq) then
			break
		end

		-- no formulas after here
		if (eq[i][column] == nil) then
			break
		end

		-- genreate and calculate formula
		local result = res[i]
		for j = column+1, #eq[i] do
			if (eq[i][j] ~= 0) then
				if (free_vars[j]) then
					result = result - (free_vars[j] * eq[i][j])
				else
				end
			end
		end
		presses[column] = result
		
		i = i + 1
	end

	--[[
	for k, v in pairs(free_vars) do
		--io.write(k .. ": " .. v .. " ")
		io.write(v .. " ")
	end
	io.write(" : { ")

	local local_sum_presses = 0
	for _, v in ipairs(presses) do
		io.write(v .. " ")
		local_sum_presses = local_sum_presses + v
	end
	io.write(" } " .. local_sum_presses)

	print()
	--]]

	return presses
end

local function guassian_elimination(equations, results)
	local eq = {} -- this is an implementation of table.clone()}
	for k, _ in ipairs(equations) do
		table.insert(eq, { table.unpack(equations[k]) })
	end
	local res = { table.unpack(results) } -- this an implementation of table.clone()

	local rref_eq, rref_res, free_vars = generate_reduced_row_echelon_form(eq, res)

	--[[
	-- print rref
	for i, x in pairs(rref_eq) do
		for _, y in ipairs(x) do
			io.write(y .. " ")
		end
		io.write("| " .. rref_res[i])
		print()
	end

	for _, v in ipairs(free_vars) do
		io.write(v .. " ")
	end
	print()
	--]]

	-- brute force the best solution
	-- get all possible inputs for free variables
	local max_result = math.max(table.unpack(results))

	local combination = {}
	for i = 1, #free_vars do
		table.insert(combination, 0)
	end

	local least_num_presses = math.maxinteger
	local best_presses = nil

	while (true) do
		-- check equations
		local curr_combination = {}
		for i = 1, #combination do
			curr_combination[free_vars[i]] = combination[i]
		end

		-- run equations
		local presses = perform_equations(rref_eq, rref_res, curr_combination)

		-- check presses
		local sum_presses = 0
		local all_positive_presses = true
		for k, v in pairs(presses) do
			if (v < 0) then
				all_positive_presses = false
				break
			end
			sum_presses = sum_presses + v
		end

		if (all_positive_presses and (sum_presses<least_num_presses)) then
			least_num_presses = sum_presses
			best_presses = presses
		end


		-- algo for counting in base max_results instead of base 10
		-- basically increase the last digit of combination until over max_result
		-- than increase the more sigificant digit and reset the less sigificant
		-- when most sigificant digit is over max_result we have tried all combinations
		-- in our case each digit represents the free variable value
		local i = #free_vars
		while (i>=0 and combination[i]==max_result) do
			combination[i] = 0
			i = i -1
		end

		if (i<1) then
			break
		end

		combination[i] = combination[i] + 1
	end

	return least_num_presses, best_presses
end


-- part 1
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
-- i have a feeling that bfs (even with prooning) wont work here??
-- so lets try to transfrom the problem in to system of linera equations
-- than use Guassian elimination to get free variables
-- and than bruteforce those free variables
-- link to explanation (https://www.reddit.com/r/adventofcode/comments/1pl8nsa/comment/ntqt12a)
-- another possible solution is to use simplex algorithm (https://www.reddit.com/r/adventofcode/comments/1pl8nsa/comment/ntqt68w)
-- another possible solution without linear algebra including recursion and dynamic programming (https://www.reddit.com/r/adventofcode/comments/1pk87hl)
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

	local eq = buttons_to_equation(button_str, #joltage)

	--[[
	-- print before gausian
	for i, x in pairs(eq) do
		for _, y in ipairs(x) do
			io.write(y .. " ")
		end
		io.write("| " .. joltage[i])
		print()
	end
	print()
	--]]

	local least_presses, best_presses = guassian_elimination(eq, joltage)


	local local_sum_presses = 0
	for _, v in ipairs(best_presses) do
		local_sum_presses = local_sum_presses + v
	end
	io.write(local_sum_presses .. " [ ")
	for _, v in ipairs(best_presses) do
		io.write(v .. " ")
	end
	print("]")

	count_all_presses = count_all_presses + least_presses

	--[[
	-- print after gaussian
	for i, x in pairs(eq_matrix) do
		for _, y in ipairs(x) do
			io.write(y .. " ")
		end
		io.write("| " .. joltage_matrix[i])
		print()
	end

	for _, v in ipairs(free_vars) do
		print(v)
	end
	--]]
end

print("Part 2: " .. count_all_presses)


local end_time = os.clock()
print("Elapsed time " .. (end_time - start_time) .. " seconds")
