


#starting vars
num_of_lit = 0
num_of_lit2 = 0

lights = []
#second part
#lights2 = []


with open('input2015_18.txt', 'r') as myfile:
	input = myfile.read().split('\n')



for i in range(len(input)):
	curr_row = []
	for j in range(len(input[i])):
		if (input[i][j] == '#'):
			curr_row.append(True)
		elif (input[i][j] == '.'):
			curr_row.append(False)
	lights.append(curr_row)
	#lights2.append(curr_row)

lights2 = lights.copy()

def game_of_life(x, y):
	next_state = lights[x][y]
	n = []

	if (x == 0): #top
		if (y == 0): #top-left
			n = [lights[x][y+1], lights[x+1][y], lights[x+1][y+1]]
		elif (y == 99): #top-right
			n = [lights[x][y-1], lights[x+1][y-1], lights[x+1][y]]
		else: #just top
			n = [lights[x][y-1], lights[x][y+1], lights[x+1][y-1], lights[x+1][y], lights[x+1][y+1]]
	elif (x == 99): #bottom
		if (y == 0): #bottom-left
			n = [lights[x-1][y], lights[x-1][y+1], lights[x][y+1]]
		elif (y == 99): #bottom-right
			n = [lights[x-1][y-1], lights[x-1][y], lights[x][y-1]]
		else: #just bottom
			n = [lights[x-1][y-1], lights[x-1][y], lights[x-1][y+1], lights[x][y-1], lights[x][y+1]]
	else : #bewteen top and bottom
		if (y == 0): #just left
			n = [lights[x-1][y], lights[x-1][y+1], lights[x][y+1], lights[x+1][y], lights[x+1][y+1]]
		elif (y == 99): #just right
			n = [lights[x-1][y-1], lights[x-1][y], lights[x][y-1], lights[x+1][y-1], lights[x+1][y]]
		else: #between left and right (normal case)
			n = [lights[x-1][y-1], lights[x-1][y], lights[x-1][y+1], lights[x][y-1], lights[x][y+1], lights[x+1][y-1], lights[x+1][y], lights[x+1][y+1]]


	if (lights[x][y]): #if on
		if (sum(n)==2 or sum(n)==3): #if 2 or 3 neighbors lit, stay lit
			next_state = True
		else:
			next_state = False #else turn off
	else: #if off
		if (sum(n)==3): #if exactily 3 neighbors lit, turn on
			next_state = True
		else:
			next_state = False #else stay off


	return next_state


for k in range(100):
	new_state = []

	for i in range(len(lights)):
		new_state_row = []
		for j in range(len(lights[i])):
			new_state_row.append(game_of_life(i, j))
		new_state.append(new_state_row)

	lights = new_state

for i in lights:
		num_of_lit += sum(i)

print("1. number of lit lights after 100 animation frames: ", num_of_lit)


#second part (bad copy)

lights2[0][0] = True
lights2[0][99] = True
lights2[99][0] = True
lights2[99][99] = True


def not_game_of_life(x, y):
	next_state = lights2[x][y]
	n = []

	if (x == 0): #top
		if (y == 0): #top-left
			return (True)
		elif (y == 99): #top-right
			return (True)
		else: #just top
			n = [lights2[x][y-1], lights2[x][y+1], lights2[x+1][y-1], lights2[x+1][y], lights2[x+1][y+1]]
	elif (x == 99): #bottom
		if (y == 0): #bottom-left
			return (True)
		elif (y == 99): #bottom-right
			return (True)
		else: #just bottom
			n = [lights2[x-1][y-1], lights2[x-1][y], lights2[x-1][y+1], lights2[x][y-1], lights2[x][y+1]]
	else : #bewteen top and bottom
		if (y == 0): #just left
			n = [lights2[x-1][y], lights2[x-1][y+1], lights2[x][y+1], lights2[x+1][y], lights2[x+1][y+1]]
		elif (y == 99): #just right
			n = [lights2[x-1][y-1], lights2[x-1][y], lights2[x][y-1], lights2[x+1][y-1], lights2[x+1][y]]
		else: #between left and right (normal case)
			n = [lights2[x-1][y-1], lights2[x-1][y], lights2[x-1][y+1], lights2[x][y-1], lights2[x][y+1], lights2[x+1][y-1], lights2[x+1][y], lights2[x+1][y+1]]


	if (lights2[x][y]): #if on
		if (sum(n)==2 or sum(n)==3): #if 2 or 3 neighbors lit, stay lit
			next_state = True
		else:
			next_state = False #else turn off
	else: #if off
		if (sum(n)==3): #if exactily 3 neighbors lit, turn on
			next_state = True
		else:
			next_state = False #else stay off


	return next_state


for k in range(100):
	new_state = []

	for i in range(len(lights2)):
		new_state_row = []
		for j in range(len(lights2[i])):
			new_state_row.append(not_game_of_life(i, j))
		new_state.append(new_state_row)

	lights2 = new_state

for i in lights2:
		num_of_lit2 += sum(i)

print("1. number of lit lights after 100 animation frames with corners allways lit: ", num_of_lit2)