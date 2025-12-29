start_time = time()
input_file = "14.txt"


function iteration_old!(recipes, a, b)
	combined = parse.(Int, split(string(recipes[a] + recipes[b]), ""))
	# we sum the values
	# than we convert them to a string
	# than we split them into string array of digits
	# than we convert them back to integers
	#	we use broadcast parse (parse.()) so it operates on each element separately, not on everyting as a whole

	# append new recipes
	append!(recipes, combined)

	# change ids of workers
	a = (((a-1)+(1 + recipes[a])) % length(recipes)) + 1
	b = (((b-1)+(1 + recipes[b])) % length(recipes)) + 1

	return a, b
end

function iteration!(recipes, a, b)
	combined = string((recipes[a]-'0') + (recipes[b]-'0'))

	recipes *= combined

	# change ids of workers
	a = (((a-1)+(1 + (recipes[a]-'0'))) % length(recipes)) + 1
	b = (((b-1)+(1 + (recipes[b]-'0'))) % length(recipes)) + 1

	return recipes, a, b
end

# part 1
line_str = readline(input_file)
num_recipes = parse(Int, line_str)
recipes = [3, 7]
#recipes = "37"
worker_a = 1
worker_b = 2

while(length(recipes) < num_recipes+10)
	global worker_a, worker_b = iteration_old!(recipes, worker_a, worker_b)
	#global recipes, worker_a, worker_b = iteration!(recipes, worker_a, worker_b)
end

# result is the last 10 recipes after the num specified in input
println("Part 1: ", join(recipes[num_recipes+1:num_recipes+10]))
#println("Part 1: ", recipes[num_recipes+1:num_recipes+10])

# string approach is waaaay slower


# part 2
println("Takes a while (~1min)")
pattern = readline(input_file)
pattern_len = length(pattern)
recipes2 = [3, 7]
recipes_len = length(recipes2)
worker_a2 = 1
worker_b2 = 2
first_occurrence = 0

while(true)
#for _ in 1:20
	global worker_a2, worker_b2 = iteration_old!(recipes2, worker_a2, worker_b2)
	start_search = max(1,recipes_len-pattern_len)
	as_string = join(recipes2[start_search:end], "")
	match = findfirst(pattern, as_string)

	global recipes_len = length(recipes2)

	if (match != nothing)
		global first_occurrence = start_search + match.start - 1
		break
	end
end

println("Part 2: ", first_occurrence-1)


elapsed_time = time() - start_time
println("Elapsed time:" , elapsed_time, " seconds")
