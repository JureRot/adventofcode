import collections
import itertools


#staring happiness
people = collections.defaultdict(dict)


#starting vars
best_arr = []
happ_change = 0


with open('input2015_13.txt', 'r') as myfile:
	input = myfile.read().split('\n')



for i in input:
	i_list = i.split(' ')

	if (i_list[2] == "gain"):
		people[i_list[0]][i_list[10][:-1]] = int(i_list[3])
	elif (i_list[2]== "lose"):
		people[i_list[0]][i_list[10][:-1]] = -1 * int(i_list[3])

pk = itertools.permutations(people.keys())

for i in pk:
	temp_change = 0
	for j in range(len(i)):
		if (j == 0):
			temp_change += people[i[j]][i[len(i)-1]]
			temp_change += people[i[j]][i[j+1]]
		elif (j == len(i)-1):
			temp_change += people[i[j]][i[j-1]]
			temp_change += people[i[j]][i[0]]
		else:
			temp_change += people[i[j]][i[j-1]]
			temp_change += people[i[j]][i[j+1]]

	
	if (temp_change > happ_change):
		happ_change = temp_change
		best_arr = i

print("1. the total change of happines for the best arragement: ", happ_change)


#second part (including myself)
best_arr2 = []
happ_change2 = 0

people2 = people.copy()

for i in people.keys():
	people2["Jure"][i] = 0
	people2[i]["Jure"] = 0


pk2 = itertools.permutations(people2.keys())

for i in pk2:
	temp_change = 0
	for j in range(len(i)):
		if (j == 0):
			temp_change += people2[i[j]][i[len(i)-1]]
			temp_change += people2[i[j]][i[j+1]]
		elif (j == len(i)-1):
			temp_change += people2[i[j]][i[j-1]]
			temp_change += people2[i[j]][i[0]]
		else:
			temp_change += people2[i[j]][i[j-1]]
			temp_change += people2[i[j]][i[j+1]]

	
	if (temp_change > happ_change2):
		happ_change2 = temp_change
		best_arr2 = i

print("2. the total change of happines for the best arragement including myself: ", happ_change2)