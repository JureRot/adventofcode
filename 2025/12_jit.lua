local Queue = require("queue")

local start_time = os.clock()

local lines = {}
for line in io.lines("12.txt") do
    table.insert(lines, line)
end


-- part 1
local current_shape = nil
local reading_shape = false
local shapes = {}
local current_shape_height = 0
local current_shape_width = 0
local current_shape_area = 0
local num_acceptable_regions = 0

for _, line in ipairs(lines) do
	if (string.sub(line, 2, 2) == ":") then
		-- means we are starting to read a shape
		-- reset all values
		reading_shape = true
		current_shape = string.sub(line, 1, 1)
		current_shape_height = 0
		current_shape_width = 0
		current_shape_area = 0
	elseif (line == "") then
		if (reading_shape) then
			-- means we stopped reading a shape
			-- write all its values
			reading_shape = false
			shapes[current_shape] = { w = current_shape_width, h = current_shape_height, a = current_shape_area }
		end
	elseif (string.sub(line, 6, 6) == ":") then
		-- means we are reading an area
		local num_all_regions = 0
		local dimensions = { w = string.sub(line, 1, 2), h = string.sub(line, 4, 5) }

		local shape_list_str = string.sub(line, 8)
		local shape_list = {}
		local shape_index = 0
		for match in string.gmatch(shape_list_str, "[^ ]+") do
			shape_list[tostring(shape_index)] = match
			num_all_regions = num_all_regions + match
			shape_index = shape_index + 1
		end

		local condition_met = false

		-- check if region big enough to comfortably fit all shapes -> definitely fits
		local max_width = 0
		local max_height = 0
		for k, v in pairs(shapes) do
			if (v.w > max_width) then
				max_width = v.w
			end
			if (v.h > max_height) then
				max_height = v.h
			end
		end

		if ((math.floor(dimensions.w/max_width))*(math.floor(dimensions.h/max_height)) >= num_all_regions) then
			num_acceptable_regions = num_acceptable_regions + 1
			--print("definitely fits")
			condition_met = true
		end
		
		-- check if shapes area is bigger than region area -> definitely doesnt fit
		local total_area = 0
		for k, v in pairs(shape_list) do
			total_area = total_area + (v * shapes[k].a)
		end

		if (total_area > (dimensions.w * dimensions.h)) then
			--print("definitely DOESNT fit")
			condition_met = true
		end

		if (not condition_met) then
			print("should not happen")
		end

	else
		if (reading_shape) then
			-- still reading a shape

			-- increase its height
			current_shape_height = current_shape_height + 1

			-- increase / check its width
			if (#line > current_shape_width) then
				current_shape_width = #line
			end

			-- find all occurrences of # and increase shapes area
			local char = 1
			while (true) do
				local start = string.find(line, "#", char, true)
				if (start == nil) then
					break
				end
				char = start + 1
				current_shape_area = current_shape_area + 1
			end
		end
	end
end

-- this is an NP-complete problem
-- i dont even know how to approach it
-- there is a hack
-- check if number of pressents is less than widt//3 * height// of region -> than it most definitely fit without any packing
-- check if the area of all the pressents is greater than the area of the region -> than it most definitely doesnt fit

print("Part 1: " .. num_acceptable_regions)


local end_time = os.clock()
print("Elapsed time " .. (end_time - start_time) .. " seconds")
