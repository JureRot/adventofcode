import collections

#default location (standard cartesian cooriante definition)
x = 0
y = 0

#houses
houses = collections.defaultdict(int)

with open('input2015_03.txt', 'r') as myfile:
	input = myfile.read() # ^ -> up, v -> down, < -> left, > -> right


houses[(x, y)] += 1

for i in input:
	if (i == '^'):
		x += 1
	elif (i == 'v'):
		x -= 1
	elif (i == '<'):
		y -= 1
	elif (i == '>'):
		y += 1

	houses[(x, y)] += 1

print("1. Number of houses with at least one pressent: ", len(houses))


#santa and robo-santa
x1 = y1 = x2 = y2 = 0

#houses second year
houses2 = collections.defaultdict(int)

houses[(x1, y1)] += 1
houses[(x2, y2)] += 1

for index in range(0, len(input), 2):
	i = input[index]
	j = input[index+1]

	#santa
	if (i == '^'):
		x1 += 1
	elif (i == 'v'):
		x1 -= 1
	elif (i == '<'):
		y1 -= 1
	elif (i == '>'):
		y1 += 1

	houses2[(x1, y1)] += 1


	#robo-santa
	if (j == '^'):
		x2 += 1
	elif (j == 'v'):
		x2 -= 1
	elif (j == '<'):
		y2 -= 1
	elif (j == '>'):
		y2 += 1

	houses2[(x2, y2)] += 1

print("2. Number of houses with at leats one pressent with the help of robo-santa: ", len(houses2))