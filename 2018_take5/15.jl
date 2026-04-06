start_time = time()
input_file = "15.txt"

@enum UnitType begin
	Elf
	Goblin
end

mutable struct Unit
	x::Int
	y::Int
	type::UnitType
	hp::Int
	attack::Int
end

mutable struct Cell
	unit::Union{Nothing,Unit}
end

#=
struct Target
	x::Int
	y::Int
	hp::Int
end
=#

function is_in_range_of_target(map, unit)
	candidates = []
	targets = []
	i = unit.x
	j = unit.y

	# up
	push!(candidates, map[j-1][i])
	# left
	push!(candidates, map[j][i-1])
	# right
	push!(candidates, map[j][i+1])
	# down
	push!(candidates, map[j+1][i])

	# check candidates
	for c in candidates
		# if not wall and not empty and not same type and not dead
		if (c != nothing && c.unit != nothing && c.unit.type != unit.type && c.unit.hp > 0)
			push!(targets, c.unit)
		end
	end

	# sort targets by hp, and than readin order
	sort!(units; by = p -> (p.hp, p.y, p.x))

	return targets
end

function find_target_locations(map, opponents)
	target_locations = []
	target_loc_candidates = []

	for o in opponents
		# up
		push!(target_loc_candidates, [o.x, o.y-1])
		# left
		push!(target_loc_candidates, [o.x-1, o.y])
		# right
		push!(target_loc_candidates, [o.x+1, o.y])
		# down
		push!(target_loc_candidates, [o.x, o.y+1])
	end

	for i in target_loc_candidates
		c = map[i[2]][i[1]]
		# if not wall and (empty or dead)
		if (c != nothing && (c.unit == nothing || c.unit.hp > 0))
			push!(target_locations, i)
		end
	end

	# sort by reading order
	sort!(target_locations, by = p -> (p[2], p[1]))

	return target_locations
end

function find_path_to_target(map, from, to)
	println("$(from[1]),$(from[2]) -> $(to[1]),$(to[2])")

	# run a*
end

function find_location_to_move(map, from, target_locations)
	best_length = typemax(Int)
	best_location = []

	for target in target_locations
		# if best path is worse than current best we dont even check
		find_path_to_target(map, from, target)
	end


	return best_location
end

function move_unit!(map, unit, opponents)
	# find target locations
	println("find target locs")
	target_locations = find_target_locations(map, opponents)

	find_location_to_move(map, [unit.x, unit.y], target_locations)
end

function round!(map, units, elves, goblins)
	# sort units into reading order to take their turn
	sort!(units; by = p -> (p.y, p.x))

	for u in units
		# skip dead units
		if (u.hp <= 0)
			continue
		end

		type = u.type
		#println("$type -> $(u.x), $(u.y)")

		# if no opponents we end combat
		opponent_num = 0
		if (type == Elf)
			opponent_num = length(goblins)
		else
			opponent_num = length(elves)
		end
		if (opponent_num == 0)
			println("END COMBAT")
			break
		end

		# is in range of target
		targets = is_in_range_of_target(map, u)
		if (length(targets) == 0)
			println("need to move")
			# need to find target location to move
			if (type == Elf)
				move_unit!(map, u, goblins)
			else
				move_unit!(map, u, elves)
			end

			
			# after moving need to recheck if in range of target
		end

		if (length(targets) > 0)
			# is in range of target
			# targets should already be sorted
			target = first(targets)

			# attack target
			target.hp -= u.attack
		end
	end
end

function draw_map(map)
	for j in eachindex(map)
		for i in eachindex(map[j])
			cell = map[j][i]
			if (cell == nothing)
				print("#")
			elseif (cell.unit == nothing)
				print(".")
			else
				if (cell.unit.type == Elf)
					print("E")
				else
					print("G")
				end
			end
		end
		println()
	end
end


# part 1
map = Any[]
units = []
elves = []
goblins = []
unit_hp = 200
unit_attack = 3

lines = readlines(input_file)

for j in eachindex(lines)
	line = lines[j]
	curr_layer = []

	for i in eachindex(line)
		char = line[i]
		if (char == '#')
			push!(curr_layer, nothing)
		elseif (char == '.')
			cell = Cell(nothing)
			push!(curr_layer, cell)
		else
			if (char == 'E')
				unit = Unit(i, j, Elf, unit_hp, unit_attack)
				push!(elves, unit)
			else
				unit = Unit(i, j, Goblin, unit_hp, unit_attack)
				push!(goblins, unit)
			end

			push!(units, unit)
			cell = Cell(unit)
			push!(curr_layer, cell)
		end
	end

	push!(map, curr_layer)
end

display(units)
draw_map(map)

round!(map, units, elves, goblins)
display(units)

println("Part 1: ", "buhtek")


elapsed_time = time() - start_time
println("Elapsed time:" , elapsed_time, " seconds")
