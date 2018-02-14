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

reversements = collections.defaultdict(list)

input = """e => H
e => O
H => HO
H => OH
O => HH""".split('\n')

mol = "HOHOHO"

for i in input:
	i_list = i.split(' ')
	reversements[i_list[2]].append(i_list[0])

"""defabricated = set(mol)

new_defabricated = set()

print(len(defabricated), len(new_defabricated))
replace(mol, new_defabricated, reversements)
print(len(defabricated), len(new_defabricated))

defabricated = new_defabricated.copy() 

print(len(defabricated), len(new_defabricated))
[replace(i, new_defabricated, reversements) for i in defabricated]
print(len(defabricated), len(new_defabricated))

defabricated = new_defabricated.copy() 

print(len(defabricated), len(new_defabricated))
[replace(i, new_defabricated, reversements) for i in defabricated]
print(len(defabricated), len(new_defabricated))"""

defabricated = set([mol])

n = 0
for i in range(10):
	n += 1

	new_defabricated = set()

	[replace(i, new_defabricated, reversements) for i in defabricated]
	
	if ("e" in new_defabricated):
		print("2. number of iterations to get the mol from e: ", n)
		break

	defabricated = new_defabricated.copy()
	print(n, len(defabricated))


"""
idea here:
we do the first part in reverse. Thus we limit our tree of search  a lot It works, but still not fast enough.
new idea A* or greedy approach where we always replace the longest possible replacement
"""

