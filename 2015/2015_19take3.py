import collections
import re


#staring vars
replacements = collections.defaultdict(list)

distinct_outputs = set()



with open('input2015_19.txt', 'r') as myfile:
	input = myfile.read().split('\n')



mol = input.pop(-1) #decalre the molecule for which we have to calibrate
input.pop(-1) #new line removal

for i in input: #for every input
	i_list = i.split(' ')
	replacements[i_list[0]].append(i_list[2]) #we make a list of all its possible outputs


def replace(in_str, out_set, instruction):
	for k in instruction.keys(): #for every input
		it = re.finditer(k, in_str) #find all matches in the mol
		for i in it: #for every match
			for j in instruction[k]: #for every possible output for this input k
				out_set.add(in_str[:i.start()] + j + in_str[i.end():]) #add a string to set (replacements will be ignored)

replace(mol, distinct_outputs, replacements)

print("1. number of all distinct molecules created with one replacement: ", len(distinct_outputs))




#second part (reverse of above)
#greedy. always take the longest possible revercement

reversements = collections.defaultdict(str) #reserve the space 


for i in input: 
	i_list = i.split(' ')
	reversements[i_list[2]]= i_list[0] #create a dict of output:input (because we are going in reverse here)
 


def replace_longest(in_str, out_set, instruction): 
	arrs = []
	for i in instruction.keys():
		arrs.append(i)
	arrs.sort(key=len, reverse=True) #makes list of all keys(outputs) ordered in reverse by lengthh of string

	for i in arrs: #goes over outputs (from longest to shortest)
		se = re.search(i, in_str)
		if (se): #if there is a match
			it = re.finditer(i, in_str) #makes iterator
			for j in it: #and makes replacement for every match found
				out_set.add(in_str[:j.start()] + instruction[i] + in_str[j.end():])
			return (None) #ends, so we only replace the longest match (greedy, not necessarily the right answer, or even an answer)


deformed = set([mol]) #var for holding iterations

n = 0 #counter

while (True): #still takes a while
	n += 1
	new_deformed = set() #helping var for holding temp values of iteration

	[replace_longest(i, new_deformed, reversements) for i in deformed] #for every value in set we replace the longes match

	if ("e" in new_deformed): #if e is in the latest iteration we output and end
		print("2. number of iterations to formulated mol from e:", n)
		break

	deformed = new_deformed.copy() #else we get ready for new iteration


"""
idea here:
A* / greedy approach where we always replace the longest possible replacement / CYK algorithm
"""

#This solution works, because there is only one possible path from e to mol, and it uses the greedy algorithm, by always choosing the replacement which causes the greatest change in len

#I DONT FEEL LIKE DOING THE A* AND CYK RIGHT NOW, BUT IN THE FUTURE, WHEN YOU GO OVER ALGORITHMS, MAKE SURE YOU COME BACK TO THIS AND APPLY IT HERE.