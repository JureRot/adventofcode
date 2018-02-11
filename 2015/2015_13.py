import collections
import itertools


#staring happiness
people = collections.defaultdict(dict)


#starting vars
best_arr = []
happ_change = 0



for i in input:
	i_list = i.split(' ') #splits using spaces

	if (i_list[2] == "gain"): #if gain
		people[i_list[0]][i_list[10][:-1]] = int(i_list[3]) #adds the value at this person for this personn
	elif (i_list[2]== "lose"): #if lose
		people[i_list[0]][i_list[10][:-1]] = -1 * int(i_list[3]) #adds negative

pk = itertools.permutations(people.keys()) #makes permutations of all the people (order of all the people)

for i in pk: #for every permutaton possible
	temp_change = 0
	for j in range(len(i)): #goes over all people
		if (j == 0): #for the first one we must add the last one
			temp_change += people[i[j]][i[len(i)-1]]
			temp_change += people[i[j]][i[j+1]]
		elif (j == len(i)-1): #for the last one we must add the first one
			temp_change += people[i[j]][i[j-1]]
			temp_change += people[i[j]][i[0]]
		else: #for in between we have ne problem
			temp_change += people[i[j]][i[j-1]]
			temp_change += people[i[j]][i[j+1]]

	
	if (temp_change > happ_change): #if total betterr than the best till no, we change
		happ_change = temp_change
		best_arr = i

print("1. the total change of happines for the best arragement: ", happ_change)


#second part (including myself) (just add our selves with all zeros, repeat the whole process)
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