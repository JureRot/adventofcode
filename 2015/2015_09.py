import collections
import itertools
import sys

#starting locations and distances
locations = collections.defaultdict(dict) #for declaring dict in inside a dict (could be done otherwise with first delaring a firt level key, and than inserting a dicti into it)

#starting lengths and paths
length_min = sys.maxsize
path_min = []
#second part
length_max = 0 #sys.minsize ???
path_max = []



with open('input2015_09.txt', 'r') as myfile:
	input = myfile.read().split('\n')


for i in input: #creates all locations and paths to all other locations (two way)) as dict of dicts
	i_list = i.split(' ')
	locations[i_list[0]][i_list[2]] = int(i_list[4]) 
	locations[i_list[2]][i_list[0]] = int(i_list[4])
	

def get_path_lenght(l):
	temp_len = 0
	for i in range(len(l)-1):
		temp_len += locations[l[i]][l[i+1]]

	return (temp_len)




for k1, v1 in locations.items(): #for every location
	k2 = [k2 for k2, v2 in v1.items()] #makes a list of all other locations (to those we know the path)

	pk2 = list(itertools.permutations(k2)) #cr5eates all permutations of other locations

	for i in pk2: #for every permutation
		l = list(i)
		l.insert(0, k1) #inserts the starting location to the beginning
		temp_len = get_path_lenght(l)
		
		if (temp_len<length_min):
			length_min = temp_len
			path_min = l

		if (temp_len>length_max):
			length_max = temp_len
			path_max = l

print("1. the length of the shortest route: ", length_min)
print("12 the length of the longest route: ", length_max)