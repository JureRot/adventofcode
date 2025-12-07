local start_time = os.clock()

local lines = {}
for line in io.lines("05.txt") do
    table.insert(lines, line)
end


local function insert_range(ranges, start, stop)
    local curr_s = tonumber(start)
    local curr_e = tonumber(stop)

    -- if ranges empty we can just insert
    if (#ranges == 0) then
        local instance = {
            s = curr_s,
            e = curr_e,
            deleted = false
        }
        table.insert(ranges, instance)
    else
        -- check all existing ranges if current one interacts with them
        for i = 1, #ranges do
            if (ranges[i].deleted) then
                ::contnue::
            end
            local exist_s = ranges[i].s
            local exist_e = ranges[i].e
    
            -- look if current range is overlapping (in any way) with existing (non-deleted) range
            if (
                --(curr_s >= exist_s and curr_s <= exist_e) or
                --(curr_e >= exist_s and curr_e <= exist_e) or
                --(exist_s >= curr_s and exist_s <= curr_e) or
                --(exist_e >= curr_s and exist_e <= curr_e)
                not (curr_e < exist_s or curr_s > exist_e)
            ) then
                ranges[i].deleted = true -- mark exising one as deleted
                curr_s = math.min(curr_s, exist_s) -- set the boundaries for current to min / max
                curr_e = math.max(curr_e, exist_e)

                -- must not break here, because we need to check all existing ranges
            end
        end

        -- insert current range as non-deleted
        local instance = {
            s = curr_s,
            e = curr_e,
            deleted = false
        }
        table.insert(ranges, instance)
    end

    return ranges
end


-- part 1
local num_fresh = 0
local found_empty = false
local fresh = {}

for i = 1, #lines do
	local line = lines[i]

	if (line == "") then
		found_empty = true
    else
        if (not found_empty) then
            local ranges = {}
            for j in string.gmatch(line, "[^-]+") do
                table.insert(ranges, j)
            end

            local instance = {
                s = ranges[1],
                e = ranges[2]
            }
            table.insert(fresh, instance)
        else
            local found = false
            for j = 1, #fresh do
                local s = tonumber(fresh[j].s)
                local e = tonumber(fresh[j].e)
                local n = tonumber(line)
                if ((n>=s) and (n<=e)) then
                    found = true
                    break
                end
            end

            if (found) then
                num_fresh = num_fresh + 1
            end
        end
    end
end

print("Part 1: " .. num_fresh)


-- part 2
local num_fresh2 = 0
local fresh2 = {}

for i = 1, #lines do
	local line = lines[i]

	if (line == "") then
        break
    else
        local ranges = {}
        for j in string.gmatch(line, "[^-]+") do
            table.insert(ranges, j)
        end

        insert_range(fresh2, ranges[1], ranges[2])
    end
end

for i = 1, #fresh2 do
    if (not fresh2[i].deleted) then
        num_fresh2 = num_fresh2 + (fresh2[i].e - fresh2[i].s) + 1
    end
end

print("Part 2: " .. num_fresh2)


local end_time = os.clock()
print("Elapsed time " .. (end_time - start_time) .. " seconds")