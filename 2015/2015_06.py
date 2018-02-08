

#define and initialize the starting light states for all 1000x1000 lights
lights = []

#lights for second part (could be done with only one and for the first part just cound the number of non-zero values)o
lights2 = []

for i in range(1000):
	lights.append([])
	lights2.append([])
	for j in range(1000):
		lights[i].append(False)
		lights2[i].append(0)


#numnber of lights lit
number = 0

#total amount of illumination for second part
lumens = 0


with open('input2015_06.txt', 'r') as myfile:
	input = myfile.read().split('\n')


def execute_operation(op, startX, startY, stopX, stopY, lights, lights2): #op=0 -> turn off, op=1 -> turn on, op=2 -> toggle
	if (op == 0):
		for i in range(startX, stopX+1): #the loops cout be outside the ifs, but that would mean we check op 1000x1000 times instead of once (but we have repeating code)
			for j in range(startY, stopY+1):
				lights[i][j] = False

				lights2[i][j] -= 1
				if (lights2[i][j] < 0):
					lights2[i][j] = 0

	elif (op == 1):
		for i in range(startX, stopX+1):
			for j in range(startY, stopY+1):
				lights[i][j] = True

				lights2[i][j] += 1

	elif(op == 2):
		for i in range(startX, stopX+1):
			for j in range(startY, stopY+1):
				lights[i][j] = not lights[i][j]

				lights2[i][j] += 2

	return lights



for i in input:
	i_list = i.split(' ')
	
	if (len(i_list) == 4):
		start = i_list[1].split(',')
		stop = i_list[3].split(',')

		lights = execute_operation(2, int(start[0]), int(start[1]), int(stop[0]), int(stop[1]), lights, lights2)
	else:
		start = i_list[2].split(',')
		stop = i_list[4].split(',')

		if (i_list[1] == 'off'):
			lights = execute_operation(0, int(start[0]), int(start[1]), int(stop[0]), int(stop[1]), lights, lights2)
		elif (i_list[1] == 'on'):
			lights = execute_operation(1, int(start[0]), int(start[1]), int(stop[0]), int(stop[1]), lights, lights2)

for row in lights:
	number += sum(row)


for row in lights2:
	lumens += sum(row)


print("1. number of lit lights: ", number)
print("2. total brightness of the lights: ", lumens)