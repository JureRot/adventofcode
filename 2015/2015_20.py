import math



#starting vars 
input = "34000000"


"""i = 0 #will work, still somewhat bad and slow

for i in range(1, math.ceil(int(input)/10)):
	#i += 1
	temp_sum = 0
	for j in range(1, i+1):
		if (i%j == 0):
			temp_sum += 10 * j

	if (temp_sum >= int(input)):
		print("1. the first house with number of pressents at least as much as input: ", i)
		break

	print(i)"""


def get_divisors(n):	#algorithm for finding all divisors of any number
	divisors = []

	for i in range(1, math.ceil(math.sqrt(n))): #ceil because we need to include the floor of this number (floor+1 = ceil)
		if (n%i == 0):
			divisors.append(i)
			if (i != n/i):
				divisors.append(int(n/i))

	return (divisors)



i = 0

while (True): #will still take a while (1 min) but its doable
	i += 1
	temp_sum = sum([10*i for i in get_divisors(i)])

	if (temp_sum >= int(input)):
		print("1. the first house with number of pressents at least as much as input: ", i)
		break



#second part

def get_divisors_with_decay(n):
	divisors = []

	for i in range(1, math.ceil(math.sqrt(n))):
		if (n%i == 0):
			if (n/i <= 50): #if elf visited less than 50 houses
				divisors.append(i)
			if (i != n/i):
				if (n / (n/i) <= 50): #if elf visited less than 50 houses
					divisors.append(int(n/i))

	return (divisors)


i = 0

while (True): #will still take a while (1 min) but its doable
	i += 1
	temp_sum = sum([11*i for i in get_divisors_with_decay(i)])

	if (temp_sum >= int(input)):
		print("2. the first house with number of pressents at least as much as input with lazy elves: ", i)
		break