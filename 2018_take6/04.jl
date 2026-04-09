start_time = time()

input_file = "04.txt"

function get_mode(arr)
	if (length(arr) == 0)
		return nothing
	end

	counts = Dict{eltype(arr), Int}()
	for i in arr
		counts[i] = get(counts, i, 0) + 1
		# get(collecdton, key, default) -> get the value of key or creates is (one less if required)
	end
	return argmax(counts)
end

lines = readlines(input_file)
lines = sort(lines)

# part 1
hours = [Int[] for _ in  1:60] # create array of 60 empty arrays
current_guard = 0
sleep_start = 0

#for line in eachline(input_file)
for line in lines
	line = replace(line, r"[\[\]]" => "") # remove [ and ]
	line = replace(line, r"[-:]" => ' ') # make all values delimited by space
	split_line = split(line, ' ')

	minute = parse(Int, split_line[5])
	action = split_line[7]

	if (first(action) == '#')
		global current_guard = parse(Int, action[2:end])
	elseif (action == "asleep")
		global sleep_start = minute
	else
		#println("wakes -> write sleep")
		#println("guard ", current_guard, " slept from ", sleep_start, " to ", minute-1)
		for i in sleep_start:minute-1
			push!(hours[i+1], current_guard)
		end
	end
end

# get the mode (most common value) of array
flattened = vcat(hours...) # flattens array
sleepiest_guard = get_mode(flattened)

sleepiest_minute = 0
num_sleeps = 0

for i in 1:length(hours)
	# get how many times has the eepiest guard slept for every minute
	times_slept = count(==(sleepiest_guard), hours[i])
	# count(condition, collection) counts how many elements meet the condition
	if (times_slept > num_sleeps)
		global num_sleeps = times_slept
		global sleepiest_minute = i-1
	end
end

println("Day 4 part 1: ", sleepiest_guard*sleepiest_minute)


# part 2
# lazily reuse part 1
sleepiest_guard2 = 0
sleepiest_minute2 = 0
num_sleeps2 = 0

for i in 1:length(hours)
	sleepiest = get_mode(hours[i])
	times_slept = count(==(sleepiest), hours[i])
	if (times_slept > num_sleeps2)
		global num_sleeps2 = times_slept
		global sleepiest_minute2 = i-1
		global sleepiest_guard2 = sleepiest
	end
end

println("Day 4 part 2: ", sleepiest_guard2*sleepiest_minute2)


elapsed_time = time() - start_time;
println("Elapsed time: ", elapsed_time, " s")
