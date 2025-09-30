local start_time = os.clock()

print("buhtk")

local lines = {}
for line in io.lines("test.txt") do
	table.insert(lines, line)
end

-- for iterator in lines
for i,line in ipairs(lines) do
	print(line)
end


-- for range from 1 to lenght of lines (remember starts with index of 1)
for i = 1,#lines do
	print(lines[i])
end

local end_time = os.clock()
print("Elapsed time: " .. (end_time - start_time) .. " s")
