#starting floor = 0
floor = 0
#starting position = 0 (should be 1 -> is changed at the beginning of the loop)
position = 0 
position_found = False

with open('input2015_01.txt', 'r') as myfile:
	input = myfile.read()

#( -> one floor up, ) -> one floor down

for i in input:
	position += 1

	if (i == '('):
		floor += 1
	elif (i == ')'):
		floor -= 1

	if (floor == -1 and not position_found):
		print("2. position where Santa goes to basement: ", position)
		position_found = True

print("1. instructions send Santa to floor: ", floor)