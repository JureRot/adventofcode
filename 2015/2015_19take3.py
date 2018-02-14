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


"""
idea here:
A* / greedy approach where we always replace the longest possible replacement / CYK algorithm
"""

