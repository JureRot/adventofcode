import collections
import re


#staring vars
replacements = collections.defaultdict(list)

distinct_outputs = set()

fabricated = {"e"}



with open('input2015_19.txt', 'r') as myfile:
	input = myfile.read().split('\n')



mol = input.pop(-1) #decalre the molecule for which we have to calibrate
input.pop(-1) #new line removal

for i in input: #for every input
	i_list = i.split(' ')
	replacements[i_list[0]].append(i_list[2]) #we make a list of all its possible outputs


"""če prou štekam je št useh kobinacij sam št vnosov krat št možnih zmenjav tega vnosa, za vse vnose, seštet 
(ker nardimo samo eno zamenjavo (samo en input zamenjamo z outputom))

to bo verjetn neki z regexom spet (finditer)
za uak k v replacements najdemov vsa mesta in usako mesto zamenamo za vsemi možnimi
use dajemo v nek set al neki, da se ponovnitve izničjo. tada
"""
def replace(in_str, out_set):
	for k in replacements.keys(): #for every input
		it = re.finditer(k, in_str) #find all matches in the mol
		for i in it: #for every match
			for j in replacements[k]: #for every possible output for this input k
				out_set.add(in_str[:i.start()] + j + in_str[i.end():]) #add a string to set (replacements will be ignored)

replace(mol, distinct_outputs)

print("1. number of all distinct molecules created with one replacement: ", len(distinct_outputs))


#second part
n = 0

while (True): 
	n += 1
	new_fabricated = set()
	for i in fabricated:

		replace(i, new_fabricated)

	if (mol in new_fabricated):
		print("2. number of iterations to get the mol:", n)
		break
	print(n)
	fabricated = new_fabricated
		
"""
idea here:
we start with e and we make all possible replacements until we get to our given mol. This is breadth-first search. It will find it, but will take a while
New idea, we do this in reverse. Thus we limit our tree of search  a lot.
"""

