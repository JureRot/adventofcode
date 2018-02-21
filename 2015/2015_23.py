


#stargin vars
registers = {'a':0, 'b':0}

instructions = []



with open('input2015_23.txt', 'r') as myfile: #read the input
	input = myfile.read().split('\n')


instructions = list(input) #make a list of all instructions (as strings). list because it needs to be in order (could have done other way, for example: just walj over input)

def execute(s, i): #function for executing the instructions. returns new i, (if normal -> +1, if jump -> the appropriate location)
	s_list = s.split()
	new_i = i

	if (s_list[0] == "hlf"): #half
		registers[s_list[1]] = registers[s_list[1]] // 2 #non-negative integers (whole number divisiono / floor division)
		new_i += 1

	elif (s_list[0] == "tpl"): #triple
		registers[s_list[1]] = registers[s_list[1]] * 3
		new_i += 1

	elif (s_list[0] == "inc"): #increase
		registers[s_list[1]] = registers[s_list[1]] + 1
		new_i += 1

	elif (s_list[0] == "jmp"): #jump
		if (s_list[1][0] == '+'): #if the first char of offset is +, we increase the i by the rest offset
			new_i += int(s_list[1][1:])
		else: #else we decrease the i by the rest of offset
			new_i -= int(s_list[1][1:])
		
	elif (s_list[0] == "jie"): #jup if odd
		if (registers[s_list[1][:-1]] % 2 == 0): #if value of r is cleanly divisible by 2 (is even)
			if (s_list[2][0] == '+'):
				new_i += int(s_list[2][1:])
			else:
				new_i -= int(s_list[2][1:])
		else:
			new_i += 1

	elif (s_list[0] == "jio"):
		if (registers[s_list[1][:-1]] == 1): #if value of r is equal to 1
			if (s_list[2][0] == '+'):
				new_i += int(s_list[2][1:])
			else:
				new_i -= int(s_list[2][1:])
		else:
			new_i += 1

	return (new_i) #return the new value of i (new location)

i = 0

while (True): #infinte loop
	if (i >= len(instructions)): #break condition -> if location of next instruction is outside our "memory", if location greater than the number of instructions
		break
	i = execute(instructions[i], i)


print("1. the value of register b after executing all instructions:", registers['b'])


#second part, same process
registers = {'a':1, 'b':0} #we reuse the same vars, makes it simpler

i = 0

while (True):
	if (i >= len(instructions)):
		break
	#print(i, registers['a'], registers['b'])
	i = execute(instructions[i], i)


print("2. the value of register b after executing all instructions if a starts as 1:", registers['b'])

"""
hlf r (set r to half its value)
tpl r (set r to triple its value)
inc r (increase the value of r by 1)
jmp offset (jump to +/- instruction indicated by offset. +/-0 is infinite loop(jumping to itself), +1 is next instruction)
jie r, offset (jump if even. if r is even jump to instruction indicated by offset)
jio r, offset is (jump if one, NOT ODD. if r is ==1 jump to instruction indicated by offset)
"""