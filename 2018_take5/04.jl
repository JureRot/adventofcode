start_time = time()
input_file = "04.txt"


function set_sleep_schedule!(sleep_schedules, id, start, stop)
	for i in start+1:stop # intead of start:stop-1 because julia starts counting with 1
		sleep_schedules[id][i] += 1
	end
end


# part 1
lines = readlines(input_file)
sort!(lines)
current_guard = nothing
start_hour = nothing
start_minute = nothing
sleep_schedules = Dict()

sleepies_guard = nothing
most_minutes_slept = 0
most_slept_minute = nothing

for line in lines
	line = replace(line, '#' => "")
	split_line = split(line, [' ', ':', '[', ']'])
	hour = parse(Int, split_line[3])
	minute = parse(Int, split_line[4])
	keyword = split_line[6]
	guard_id = split_line[7]
	if (keyword == "Guard")
		# guard starts
		global current_guard = guard_id
	elseif (keyword == "falls")
		# note start time
		global start_hour = hour
		global start_minute = minute

		#start_minute>0 || throw(AssertionError("start minute is 0"))
	elseif (keyword == "wakes")
		# end counting -> write
		if (!haskey(sleep_schedules, current_guard))
			#sleep_schedules[current_guard] = zeros(60)
			sleep_schedules[current_guard] = fill(0, 60)
		end

		set_sleep_schedule!(sleep_schedules, current_guard, start_minute, minute)
	end
end

for (k, v) in sleep_schedules
	if (sum(v) > most_minutes_slept)
		global most_minutes_slept = sum(v)
		global sleepies_guard = parse(Int, k)
		global most_slept_minute = argmax(v) - 1 # find the indes of the max value
		# altervantive: println(findfirst(x -> x == maximum(v), v))
		# -1 because we +1 in set_sleep_schedule
	end
end

println("Part 1: ", sleepies_guard * most_slept_minute)


# part 2
lines2 = readlines(input_file)
sort!(lines2)
current_guard2 = nothing
start_minute2 = nothing
sleep_schedules2 = Dict()

sleepies_guard2 = nothing
most_slept_minute2 = nothing
most_slept_minute2_count = 0

for line in lines2
	line = replace(line, '#' => "")
	split_line = split(line, [' ', ':', '[', ']'])
	minute = parse(Int, split_line[4])
	keyword = split_line[6]
	guard_id = split_line[7]
	if (keyword == "Guard")
		# guard starts
		global current_guard2 = guard_id
	elseif (keyword == "falls")
		# note start time
		global start_minute2 = minute

		#start_minute>0 || throw(AssertionError("start minute is 0"))
	elseif (keyword == "wakes")
		# end counting -> write
		if (!haskey(sleep_schedules2, current_guard2))
			sleep_schedules2[current_guard2] = fill(0, 60)
		end

		set_sleep_schedule!(sleep_schedules2, current_guard2, start_minute2, minute)
	end
end

for (k, v) in sleep_schedules2
	if (maximum(v) > most_slept_minute2_count)
		global most_slept_minute2_count = maximum(v)
		global most_slept_minute2 = argmax(v) - 1 # -1 because we +1 in set_sleep_schedule
		global sleepies_guard2 = parse(Int, k)
	end
end

println("Part 2: ", sleepies_guard2 * most_slept_minute2)


elapsed_time = time() - start_time
println("Elapsed time:" , elapsed_time, " seconds")
