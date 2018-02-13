import itertools


#starting vars
num_of_combinations = 0
found_any = False
least_num = 0


containers = []

with open('input2015_17.txt', 'r') as myfile:
	input = myfile.read().split('\n')


for i in input:
	containers.append(int(i)) #make alist of all the containers

#containers.sort()

for i in range(4, len(containers)): #start at 4 because we cant get 150 with only 3 container
	cc = itertools.combinations(containers, i) #for every lenght of combination from 4 to number of containers se create a all possible combinations of containers
	for j in cc: # for every of those combinations
		if (sum(j) == 150): #we chech if the sum is equal to 150
			num_of_combinations += 1 #and if true, increase the number we are seaking

	#second part
	if (not found_any and num_of_combinations > 0): #for the first combination lenth that does allow for storing 150l (we implemented this logic above with range(4,len(c)), so is the first combination set in our instance) we remember the number 
		least_num = num_of_combinations
		found_any = True
		

print("1. the number of combinations of containers for storing 150l: ", num_of_combinations)

print("2. the number of combinations of containers for storing 150l using the smallest number of containers: ", least_num)