start_time = time()
input_file = "07.txt"


mutable struct Worker
	task::Union{Nothing, String}
	time::Int
end

function get_char_time(c)
	return Int(only(c)) - 64 # only() converts string into character ??
end


# part 1
dependencies = Dict()
dep_keys = nothing
run_order = ""

for line in eachline(input_file)
	split_line = split(line, ' ')
	# make sure both nodes have entry in dependencies (we need one to have none to know where to start)
	if (!haskey(dependencies, split_line[8]))
		dependencies[split_line[8]] = Set()
	end
	if (!haskey(dependencies, split_line[2]))
		dependencies[split_line[2]] = Set()
	end
	push!(dependencies[split_line[8]], split_line[2])
end

dep_keys = collect(keys(dependencies))
# we need the collect() here because keys() returns a vector and collect() turns it into array
# we cant call sort! on vectors, but can on arrays
sort!(dep_keys)

while(length(dependencies) > 0)
	for i in dep_keys
		# find the first one with no dependencies
		if (length(dependencies[i]) == 0)
			# add it to run order
			global run_order *= i

			# delete it from dependecies and dep_keys
			delete!(dependencies, i)
			deleteat!(dep_keys, findfirst(==(i), dep_keys)) # find index of first element that equals to i and delete at that index
			# alternative with filter: filter!(x -> x!=i, dep_keys)

			# remove it as dependency for all remaining steps/nodes
			for (k, v) in dependencies
				delete!(dependencies[k], i)
			end

			break
		end
	end
end

println("Part 1: ", run_order)


# part 2
# first try normal intuitive brute-force iterative approach
dependencies2 = Dict()
running = Set() # only used to run the last task to completion
dep_keys2 = nothing
run_order2 = ""
base_time = 60 # change to 0 for test input
num_workers = 5 # change to 2 for test input
seconds = 0
workers = []

for line in eachline(input_file)
	split_line = split(line, ' ')
	# make sure both nodes have entry in dependencies (we need one to have none to know where to start)
	if (!haskey(dependencies2, split_line[8]))
		dependencies2[split_line[8]] = Set()
	end
	if (!haskey(dependencies2, split_line[2]))
		dependencies2[split_line[2]] = Set()
	end
	push!(dependencies2[split_line[8]], split_line[2])
end

dep_keys2 = collect(keys(dependencies2))
sort!(dep_keys2)

for i in 1:num_workers
	push!(workers, Worker(nothing, 0)) # here we are using a struct
 end


while(length(dependencies2)>0 || length(running)>0)
#for n in 1:50
	# remove 1 second from all running tasks
	for w in workers
		if (w.task != nothing) # again using strcut so we use . syntax to access values
			i = w.task
			w.time -= 1 # we can assign new values because we are using a mutable struct

			if (w.time == 0) # task is done
				global run_order2 *= i

				# remove task as dependency for all remaining waiting steps/nodes
				for (k, v) in dependencies2
					delete!(dependencies2[k], i)
				end

				# remove task from running
				delete!(running, i)

				# relieve this worker
				w.task = nothing
			end
		end
	end

	# assign new tasks to workers
	for w in workers
		if (w.task == nothing)
			# find new task
			for i in dep_keys2
				# find the first one with no dependencies
				if (length(dependencies2[i]) == 0)
					# assign it to worker
					get_char_time(i)
					w.task = i
					w.time = base_time + get_char_time(i)

					# delete it from dependecies and dep_keys
					delete!(dependencies2, i)
					deleteat!(dep_keys2, findfirst(==(i), dep_keys2))

					# add it to running
					push!(running, i)

					break # so we dont assign multiple tasks to single worker
				end
			end
		end
	end

	global seconds += 1
end

println("Part 2: ", seconds - 1) # -1 because we shouldnt count the last iteration where all was done


elapsed_time = time() - start_time
println("Elapsed time:" , elapsed_time, " seconds")
