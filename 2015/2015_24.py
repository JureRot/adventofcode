import functools
import operator
import sys


#starting vars
packages = []
t = 0




with open('input2015_24.txt', 'r') as myfile:
	input = myfile.read().split('\n')

s = 0
for i in input:
	packages.append(int(i))

t = sum(packages) // 3



nums = [[False  if i!=0 else True for i in range(t+1)] for i in range(len(packages))] #makes 2d array used for solving subset sum problem with dynamic programing


def make_sspm(set, t): #makes a matrix. if last last cells is True we have at least one subset that sums to t

	arr = [[False  if i!=0 else True for i in range(t+1)] for i in range(len(set))] #makes 2d array of t+1 columns, and len(set) rows
	arr.insert(0, [False if i!=0 else True for i in range(t+1)])

	#this is suset sum problem solving algorithm
	for i in range(1, len(arr)): #for each row starting at 1 (we have header row)
		for j in range(1, len(arr[i])): #for each column starting at 1 (we have 0-th sum column)
			if (j-set[i-1] >= 0): #if not outside borders (number in set not bigger than the currently wanted sum)
				arr[i][j] = arr[i-1][j] or arr[i-1][j - set[i-1]]
			else: #incudes those who would be outside borders and sets them correctly (only regarding the cell above)
				arr[i][j] = arr[i-1][j] 

	return (arr) #returns the made matrix


def get_subsets(in_set, sspm, t, max_i, subsets): #gets all subsets from subset sum problem matrix for sum t, recursivly. OUTPUTS SETS IN A WEIRD STRING FORMAT
	#print(len(subsets))
	r_set = set()

	if (sspm[len(sspm)-1][len(sspm[0])-1]): #we have subset

		j = t

		for i in range(1, max_i):
			if (in_set[i-1] <= t):
				if (sspm[i][j]):
					r_set.add(i)

		for i in r_set:
			subsets += str(in_set[i-1])+"/"+str(t)+"," #nuber chosen / sum at that point (next level of recur. will be for curr sum - number chosen)
			if (t-in_set[i-1] == 0):
				subsets += ";"
			subsets = get_subsets(in_set, sspm, t-in_set[i-1], i, subsets)
		
		
		return (subsets)
	else:
		return (None)


def decode_subsets(s, t): #gets weird string format of sets and outputs actual set of subsets
	sets = []

	all_set = [[i.split('/') for i in i.split(',')[:-1]] for i in s.split(';')[:-1]]
	#split string over ; (negating last elelment). splits that using , (negating last element). splits that using / (array inside array inside array)
	#[:-1] is used on ; and , because there is the last empty element we dont want
	
	
	for i in all_set:
		inset = []

		if (int(i[0][1]) == t): #if the branch happend at the beginning (sum at that point is the total sum we want)
			inset = [int(n) for n,k in i] #we just write the whole sequence (as it is the whole subset)

		else: #if branch in betwen (we need to prefill the inset)
			n = int(i[0][1]) #the sum at branch
			temp_t = t #the total branch

			for j in sets[-1]: #we use the last added inset (the first one is never not whole) to add the needed fill in the begining (before the branch)
				inset.append(j)
				temp_t -= j #differenciate until 0
				if (temp_t == n):
					break #we stop when we reach the branch

			inset += [int(n) for n,k in i] #and we add the remaining after branching
			

		sets.append(inset) #appends the set to the whole collection

	return (sets)



out = make_sspm(packages, t) #we make the table for the subset sum problem (quite fast)

"""gs = get_subsets(packages, out, t, len(out), "") #we recursively backtrack over the table to create all the possible subsets
#holy shit this is slow (maybe candidate for take 2) takes about 50 min (that is why we save it to a file (6MB) and than we read from it)

f = open("input2015_24textsubsets3.txt", 'w')
f.write(gs)
f.close()"""

with open('input2015_24textsubsets3.txt', 'r') as myfile: #this form is used because it closes by itself (i guess)
	text_subsets = myfile.read()

ds = decode_subsets(text_subsets, t) #we decode the weird recursive text format that the get_subsets() creates into a normal set / list

sorted_ds = sorted(ds, key=len) #we sort the subsets by lenght in increasing order

min_num = None
smallest = []

for i in sorted_ds: #we find the group of the shortest subsets
	if (min_num == None): #first one will trigger this
		min_num = len(i)
		smallest.append(i)
	else:
		if (len(i) == min_num): #all other who are the same len as the first one will also go through
			smallest.append(i)
		else:
			break #any that are longer are rejected


smallest_qe = sys.maxsize
partition = []

for i in smallest: #within the group of the smallest subsets we find the one with the smallest quatum entagelement
	if (functools.reduce(operator.mul, i) < smallest_qe): #map() applies func on every element, reduce() applies function on every element subsequently to the next one(func in this case takes 2 parameters, can be sum (mul is multiplication))
		smallest_qe = functools.reduce(operator.mul, i)
		partition = i


print("1. the quantum entanglement of the bag with the smallest ammount of packages equating to the third and the smallest entanglement: ", smallest_qe)


#second part (same but with partitioning into fourths. this means we need to do everything again (theoretically we dont need to do the make_sspm again, but everything else, we doo))
t = sum(packages) // 4

out = make_sspm(packages, t)


"""gs = get_subsets(packages, out, t, len(out), "") #holy shit this is slow (maybe candidate for take 2) takes about 50 min (that is why we save it to a file (6MB) and than we read from it)

f = open("input2015_24textsubsets4.txt", 'w')
f.write(gs)
f.close()"""


with open('input2015_24textsubsets4.txt', 'r') as myfile:
	text_subsets = myfile.read()

ds = decode_subsets(text_subsets, t)

sorted_ds = sorted(ds, key=len)

min_num = None
smallests = []

for i in sorted_ds:
	if (min_num == None):
		min_num = len(i)
		smallests.append(i)
	else:
		if (len(i) == min_num):
			smallests.append(i)
		else:
			break


smallest_qe2 = sys.maxsize
partition2 = []

for i in smallests:
	if (functools.reduce(operator.mul, i) < smallest_qe2):
		smallest_qe2 = functools.reduce(operator.mul, i)
		partition2 = i


print("2. the quantum entanglement of the bag with the smallest ammount of packages equating to the fourth and the smallest entanglement: ", smallest_qe2)



"""
this is interesting
for now the ideas:
	 Knapsack problem
	 partition problem
	 3-partition problem
	 subset sum problem (dynamic programing) (sum//3)
	 	(find all the partitions (subsets) that sum to third of whole and find the one with the smalles number of elements 
	 	(we presume that if we can get a sum of a third, the remaining cana funrther be cleanly split in half))

	 (now you see why you need the knowledge of algorithems and data structures)

for take 2 idea:
	just find all the combinations len 1->len(input) that summ up to sum(input)//3 and find the one that has the least ammount of elements + the quantum thingy
"""

"""
i've noticed that the more comlex the problem is, the uglier and unorganized my code is.
this can probably be solved with rewriting the code and thus through iterations improving it, but is somewhat stupid to do if not necessary
(of course it is fine if something is overengeneered and it isn't working).
other option is to plan the program. to first analize the problem, create a strategy for solving it and do it.
thus the code is way more organized, and straight-forward without weird turns that were repurposed after seeint they lead nowhere

I NDEED TO FIND A WAY OF PLAING THAT WORKS FOR ME (actual physical proces to become a habbit)
"""